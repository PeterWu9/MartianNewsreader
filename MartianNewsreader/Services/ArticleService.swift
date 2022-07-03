//
//  ArticlesService.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/28/22.
//

import Foundation
import NetworkingLibrary

// MARK: Dependency
protocol StorageServiceProvider {
    associatedtype Value
    init()
    func save(_ data: Value) async throws
    func retrieveData() async throws -> Value?
}


// MARK: Service and Implementation
protocol ArticleServiceProvider {
    func fetchArticles() async throws -> Articles
    func bookmark(_ article: Article) async throws
    func undoBookmark(_ article: Article) async throws
}

actor ArticleService<Storage: StorageServiceProvider>:
    ObservableObject,
    ArticleServiceProvider
where Storage.Value == [String] {
    
//    private var articles = Set<Article>()
    private let baseUrlString: String
    private let networkManager = NetworkingManager.shared
    private let storage = Storage()
    
    // Constants
    private let bookmarkKey = "bookmarked"
    
    init(baseUrlString: String) {
        self.baseUrlString = baseUrlString
    }
    
    func fetchArticles() async throws -> Articles {
        let articles: Articles = try await networkManager.get(url: baseUrlString)
        let saved = try await retrieveBookmarked()
        return articles.map { article in
            Article(
                article,
                isBookmarked: saved.contains {
                    article.id == $0
                }
            )
        }
    }
    
    func bookmark(_ article: Article) async throws {
        var saved = try await retrieveBookmarked()
        saved.insert(article.id)
        
        try await storage.save([String](saved))
    }
        
    func undoBookmark(_ article: Article) async throws {
        var saved = try await retrieveBookmarked()
        saved.remove(article.id)
        
        try await storage.save([String](saved))
    }
    
    private func retrieveBookmarked() async throws -> Set<String> {
        return Set(
            (try? await storage.retrieveData()) ?? []
        )
    }
}
