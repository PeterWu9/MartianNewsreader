//
//  ArticlesService.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/28/22.
//

import Foundation
import NetworkingLibrary

final class ArticleService: ArticleServiceProvider {
    static let baseURLString = "https://s1.nyt.com/ios-newsreader/candidates/test/articles.json"
    
    private let networkManager = NetworkingManager.shared

    func fetchArticles() async throws -> Articles {
        return try await networkManager.get(url: Self.baseURLString)
    }
}
