//
//  ArticlesListCoordinator.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/29/22.
//

import Foundation

@MainActor
final class ArticlesListCoordinator: ObservableObject, Identifiable {
    
    @Published var viewModel: ArticlesListViewModel!
    @Published var articleViewModel: ArticleViewModel?
    
    private let articleService: ArticleService
    private unowned let parent: HomeCoordinator
    
    init(
        title: String,
        articleService: ArticleService,
        parent: HomeCoordinator
    ) {
        self.parent = parent
        self.articleService = articleService
        
        self.viewModel = .init(
            title: title,
            articleService: articleService,
            coordinator: self
        )
    }
    
    func open(_ article: Article) {
        self.articleViewModel = .init(article: article, coordinator: self)
    }
    
    func toggleBookmark(_ article: Article) {
        articleViewModel?.article.isBookmarked.toggle()
    }
}
