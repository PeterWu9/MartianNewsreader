//
//  NewsFetcher.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import Foundation

// MARK: Dependencies
protocol ArticleFormat {
    var body: String { get }
}

protocol ArticleProofReader {
    // This function may be an asynchronous operation (services performed over network, database..etc)
    func proofRead(_ article: Article) async throws -> String
}

// MARK: ViewModel
@MainActor
final class ArticlesFetcher<ProofReader: ArticleProofReader>: ObservableObject {
    
    @Published private(set) var articles: Articles = []
    
    private var reader: ProofReader
    
    init(reader: ProofReader) {
        self.reader = reader
    }
        
    func fetchArticles() async throws {
        
        let fetchedArticles = try await NetworkManager.shared.getArticles()
        
        articles = try await withThrowingTaskGroup(of: Article.self) { group in
            for article in fetchedArticles {
                group.addTask {
                    // Allows strong self capture because self won't outlive the scope of throwing task group closure
                    try await self.checkCarriageAndSentenceFragment(for: article)
                }
            }
            
            var articles = Articles()
            for try await article in group {
                articles.append(article)
            }
            return articles
        }
    }
    
    func checkCarriageAndSentenceFragment(for article: Article) async throws -> Article {
        return try await Article(
            title: article.title,
            images: article.images,
            body: reader.proofRead(article)
        )
    }
}

