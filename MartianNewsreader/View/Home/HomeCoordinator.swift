//
//  HomeCoordinator.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/29/22.
//

import Foundation

enum HomeTab {
    case feed
}

@MainActor
final class HomeCoordinator: ObservableObject {
    
    @Published var tab = HomeTab.feed
    @Published var newsCoordinator: ArticlesListCoordinator!
    
    private let articleService: ArticleService
    
    init(articleService: ArticleService) {
        self.articleService = articleService
        
        self.newsCoordinator = .init(
            title: "Martian News",
            articleService: articleService,
            parent: self
        )
    }
}
