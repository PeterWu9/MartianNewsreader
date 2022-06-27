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
    
    private let stringParser = StringParser()
    
    func fetchArticles() async throws {
        let fetchedArticles = try await NetworkManager.shared.getArticles()
        self.articles = fetchedArticles.map { checkCarriageAndSentenceFragment(for: $0) }
    }
    
    func checkCarriageAndSentenceFragment(for article: Article) -> Article {
        return Article(
            title: article.title,
            images: article.images,
            body: stringParser.checkParagraphAndSentenceFragment(for: article.body)
        )
    }
}
