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
    associatedtype Key: Hashable
    associatedtype Value
    typealias StorageData = [Key: Value]
    init()
    func save(_ data: StorageData) async throws
    func retrieveData(for key: Key) async throws -> Value
}


// MARK: Service and Implementation
protocol ArticleServiceProvider {
    func fetchArticles() async throws -> Articles
    func bookmark(_ article: Article, save: Bool) async throws -> Articles
}

actor ArticleService<Storage: StorageServiceProvider>:
    ObservableObject,
    ArticleServiceProvider
where Storage.Key == String,
      Storage.Value == Articles {
    
    private var articles = Set<Article>()
    private let baseUrlString: String
    private let networkManager = NetworkingManager.shared
    private let storage = Storage()
    
    // Constants
    private let bookmarkKey = "bookmarked"
    
    init(baseUrlString: String) {
        self.baseUrlString = baseUrlString
    }
    
    func fetchArticles() async throws -> Articles {
        self.articles = try await networkManager.get(url: baseUrlString)
        return Articles(articles)
    }
    
    func loadBookmarkedArticles() async throws -> Articles {
        let bookmarkedArticles = Set(
            try await storage.retrieveData(for: bookmarkKey)
        )
        return Articles(articles.intersection(bookmarkedArticles))
    }
    
    func bookmark(_ article: Article, save: Bool) async -> Articles {
        var saved = Set<Article>(
            (try? await storage.retrieveData(for: bookmarkKey)) ?? Articles()
        )
        
        if save {
            saved.insert(article)
        } else {
            saved.remove(article)
        }
        
        let bookmarked = Articles(saved)
        try? await storage.save([bookmarkKey: bookmarked])
        return Articles(saved)
    }
}
