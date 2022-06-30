//
//  ArticleViewModel.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/29/22.
//

import Foundation

@MainActor
final class ArticleViewModel: ObservableObject, Identifiable {
    
    @Published var article: Article
    
    private unowned let coordinator: ArticlesListCoordinator
    
    init(article: Article, coordinator: ArticlesListCoordinator) {
        self.article = article
        self.coordinator = coordinator
    }
    
    func toggleBookmark() throws {
        coordinator.toggleBookmark(article)
    }
    
}
