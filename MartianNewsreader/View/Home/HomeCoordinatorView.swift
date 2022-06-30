//
//  HomeCoordinatorView.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/29/22.
//

import SwiftUI

struct HomeCoordinatorView: View {
    
    @ObservedObject var coordinator: HomeCoordinator
    
    var body: some View {
        TabView(selection: $coordinator.tab) {
            NavigationView {
                ArticleListCoordinatorView(coordinator: coordinator.newsCoordinator)
            }
            .tabItem { Label("News", systemImage: "newspaper") }
            .tag(HomeTab.feed)
        }
    }
}
