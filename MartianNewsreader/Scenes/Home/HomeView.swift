//
//  HomeView.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/29/22.
//

import SwiftUI

struct HomeView: View {
    
    @State private var selection: Tab = .today
    
    enum Tab {
        case today
        case bookmark
    }
    @EnvironmentObject var articleSource: ArticleSource<ProofReader, ArticleService>
    
    var body: some View {
        TabView(selection: $selection) {
            ArticlesListView(title: "Martian News")
                .tabItem {
                    Label("Today", systemImage: "newspaper")
                }
                .tag(Tab.today)
            
            BookmarkedArticleList(title: "Martian News")
                .tabItem {
                    Label("Bookmark", systemImage: "bookmark")
                }
                .tag(Tab.bookmark)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ArticleSource(reader: ProofReader(), articleService: ArticleService()))
    }
}
