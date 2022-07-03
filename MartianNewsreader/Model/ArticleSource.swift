//
//  NewsFetcher.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import Foundation

// MARK: ViewModel
@MainActor
final class ArticleSource: ObservableObject {
        
    @Published private(set) var articles: Articles = []
    @Published private(set) var loadingState: LoadingState = .isLoading
    
    private let readerService = ProofReaderService()
    private let articleService = ArticleService<StorageService>(baseUrlString: "https://s1.nyt.com/ios-newsreader/candidates/test/articles.json")
    
    enum LoadingState {
        case isLoading
        case completeLoading
        case hasLoadingError(Error)
    }
    
    /// Loads both articles and bookmarked articles.
    /// For the articles, each article is proofread for paragraph and punctuation before storage
    func fetchArticles() async throws {
        do {
            loadingState = .isLoading
            
            let fetchedArticles = try await articleService.fetchArticles().sorted { $0.title < $1.title }
            
            articles = try await withThrowingTaskGroup(of: Article.self) { group in
                
                for article in fetchedArticles {
                    group.addTask {
                        // Allows strong self capture because self won't outlive the scope of throwing task group closure
                        try await Article(
                            title: article.title,
                            images: article.images,
                            body: self.readerService.proofRead(article),
                            isBookmarked: article.isBookmarked
                        )
                    }
                }
                
                return try await group.reduce(into: Articles()) { articles, loadedArticle in
                    articles.append(loadedArticle)
                }
            }
            loadingState = .completeLoading
        } catch {
            loadingState = .hasLoadingError(error)
            throw error
        }
    }
}

enum ArticleSourceError: Error, LocalizedError {
    case invalidArticleIndex
}

// MARK: Bookmarks
extension ArticleSource {
    
    func bookmarkTapped(on article: Article) async throws {
        
        if let index = articles.firstIndex(of: article) {
            try await article.isBookmarked
            ? articleService.undoBookmark(article)
            : articleService.bookmark(article)
            
            articles[index].isBookmarked.toggle()
        }
    }
}

