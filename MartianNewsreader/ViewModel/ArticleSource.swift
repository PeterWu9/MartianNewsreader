//
//  NewsFetcher.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import Foundation

// MARK: Dependencies


// MARK: ViewModel
@MainActor
final class ArticleSource<ProofReader: ArticleProofReader, ArticleService: ArticleServiceProvider>: ObservableObject {
    
    @Published private(set) var articles: Articles = []
    
    private let reader: ProofReader
    private let articleService: ArticleService
    
    init(reader: ProofReader, articleService: ArticleService) {
        self.reader = reader
        self.articleService = articleService
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
            body: reader.proofRead(article)
        )
    }
}

enum ArticleSourceError: Error, LocalizedError {
    case invalidArticleIndex
}

// MARK: User Actions
extension ArticleSource {
    func bookmarkButtonTapped(_ article: Article) throws {
        guard let index = articles.firstIndex(of: article) else {
            throw ArticleSourceError.invalidArticleIndex
        }
        articles[index].isBookmarked.toggle()
        // TODO: Implement saving bookmarked articles data store (which should be async operation on a database actor
    }
}

