//
//  NewsFetcher.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import Foundation

// MARK: Dependencies
protocol ArticleProofReader {
    init()
    // Proof reading may be an asynchronous operation (could be services performed over network or a potentially long-running background operation)
    func proofRead(_ article: Article) async throws -> String
}

protocol ArticleServiceProvider {
    func fetchArticles() async throws -> Articles
}

// MARK: ViewModel
@MainActor
final class ArticlesFetcher<ProofReader: ArticleProofReader, ArticleService: ArticleServiceProvider>: ObservableObject {
    
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
                    await Task.yield()
                    // Allows strong self capture because self won't outlive the scope of throwing task group closure
                    try await self.proofRead(article)
                }
            }
            
            return try await group.reduce(into: Articles()) { articles, loadedArticle in
                articles.append(loadedArticle)
            }
        }
    }
    
    func proofRead(_ article: Article) async throws -> Article {
        return try await Article(
            title: article.title,
            images: article.images,
            body: reader.proofRead(article)
        )
    }
}

