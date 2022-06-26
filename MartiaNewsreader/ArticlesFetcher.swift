//
//  NewsFetcher.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import Foundation

@MainActor
final class ArticlesFetcher: ObservableObject {
    
    @Published private(set) var articles: Articles = []
    
    func fetchArticles() async throws {
        articles = try await NetworkManager.shared.getArticles()
    }
}
