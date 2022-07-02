//
//  ArticlesService.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/28/22.
//

import Foundation
import NetworkingLibrary

actor ArticleService: ArticleServiceProvider {
    static let baseURLString = "https://s1.nyt.com/ios-newsreader/candidates/test/articles.json"
    
    private let networkManager = NetworkingManager.shared
    private let storage = Storage.shared
    
    private enum Constant {
        static let bookmarkKey = "bookmarked"
    }
        
    func fetchArticles() async throws -> Articles {
        return try await networkManager.get(url: Self.baseURLString)
    }
    
    func bookmark(_ article: Article, save: Bool) async -> Articles {
        var saved = Set<Article>(
            (try? await storage.retrieveData(for: Constant.bookmarkKey)) ?? Articles()
        )
        
        if save {
            saved.insert(article)
        } else {
            saved.remove(article)
        }
        
        let bookmarked = Articles(saved)
        try? await storage.save([Constant.bookmarkKey: bookmarked])
        return Articles(saved)
    }    
}
