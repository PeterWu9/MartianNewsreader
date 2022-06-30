//
//  ArticlesService.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/28/22.
//

import Foundation
import NetworkingLibrary

protocol ArticleServiceProvider {
    func fetchArticles() async throws -> Articles
    func proofRead(_ article: Article) async throws -> Article
}


final class ArticleService: ArticleServiceProvider {
    static let baseURLString = "https://s1.nyt.com/ios-newsreader/candidates/test/articles.json"
    
    private let networkManager = NetworkingManager.shared
    
    private let reader = ProofReader()

    func fetchArticles() async throws -> Articles {
        return try await networkManager.get(url: Self.baseURLString)
    }
    
    func proofRead(_ article: Article) async throws -> Article {
        return try await Article(
            title: article.title,
            images: article.images,
            body: reader.proofRead(article)
        )
    }
}
