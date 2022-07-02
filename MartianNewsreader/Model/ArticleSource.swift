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
    @Published private(set) var bookmarkedArticles: Articles = []
    @Published private(set) var loadingState: LoadingState = .isLoading
    
    private var bookmarkedStorage: Set<Article> = [] {
        didSet {
            bookmarkedArticles = Articles(bookmarkedStorage)
        }
    }

    private let readerService = ProofReaderService()
    private let articleService = ArticleService<StorageService>(baseUrlString: "https://s1.nyt.com/ios-newsreader/candidates/test/articles.json")
    
    enum LoadingState {
        case isLoading
        case completeLoading
        case hasLoadingError(Error)
    }
        
    init() {
        Task {
            do {
                loadingState = .isLoading
                try await fetchArticles()
                loadingState = .completeLoading
            } catch {
                loadingState = .hasLoadingError(error)
            }
        }
    }
        
    func fetchArticles() async throws {
        
        let fetchedArticles = try await articleService.fetchArticles()
        
        articles = try await withThrowingTaskGroup(of: Article.self) { group in
            for article in fetchedArticles {
                group.addTask {
                    // Allows strong self capture because self won't outlive the scope of throwing task group closure
                    try await self.proofRead(article)
                }
            }
            
            return try await group.reduce(into: Articles()) { articles, loadedArticle in
                articles.append(loadedArticle)
            }
        }
    }
    
    private func proofRead(_ article: Article) async throws -> Article {
        return try await Article(
            title: article.title,
            images: article.images,
            body: readerService.proofRead(article)
        )
    }
}

enum ArticleSourceError: Error, LocalizedError {
    case invalidArticleIndex
}

// MARK: Bookmarks
extension ArticleSource {
    func isBookmarked(for article: Article) -> Bool {
        bookmarkedStorage.contains(article)
    }
    
    func bookmarkButtonTapped(on article: Article) async throws {
        let bookmarked = await articleService.bookmark(article, save: !isBookmarked(for: article))
        bookmarkedStorage = Set(bookmarked)
    }
}

