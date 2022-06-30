//
//  ArticleListCoordinatorView.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/29/22.
//

import SwiftUI

struct ArticleListCoordinatorView: View {
    
    @ObservedObject var coordinator: ArticlesListCoordinator
    
    var body: some View {
//        NavigationView {
            ArticlesListView(viewModel: coordinator.viewModel)
                .navigation(item: $coordinator.articleViewModel) { viewModel in
                    ArticleView(viewModel: viewModel)
                }
//        }
    }
}

