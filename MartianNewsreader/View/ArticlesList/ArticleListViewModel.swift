//
//  ArticleListViewModel.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/29/22.
//

import Foundation

@MainActor
final class ArticlesListViewModel: ObservableObject {
    
    @Published var title: String
    @Published var articles = Articles()
    
    private let articleService: ArticleService
    private unowned let coordinator: ArticlesListCoordinator
    
    init(
        title: String,
        articleService: ArticleService,
        coordinator: ArticlesListCoordinator
    ) {
        self.title = title
        self.coordinator = coordinator
        self.articleService = articleService
    }
    
    func fetchArticles() async throws {
        
        let fetchedArticles = try await articleService.fetchArticles()
        
        let articles: Articles = try await withThrowingTaskGroup(of: Article.self) { group in
            for article in fetchedArticles {
                group.addTask {
                    // Allows strong self capture because self won't outlive the scope of throwing task group closure
                    try await self.articleService.proofRead(article)
                }
            }
            
            return try await group.reduce(into: Articles()) { articles, loadedArticle in
                articles.append(loadedArticle)
            }
        }
        self.articles = articles
    }
    
    func open(_ article: Article) {
        self.coordinator.open(article)
    }
    
    
}
