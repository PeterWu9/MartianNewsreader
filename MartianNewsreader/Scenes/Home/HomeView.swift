//
//  HomeView.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/29/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var articleSource: ArticleSource
    @State private var selection: Tab = .today
    
    enum Constant {
        static let mainTitle = "Martian News"
        static let bookmarkSubtitle = "Bookmarks"
        static let newsPaperImageName = "newspaper"
        static let bookmarkImageName = "bookmark"
    }
    
    enum Tab: String {
        case today = "Today"
        case bookmarks = "Bookmarks"
    }
    
    
    var body: some View {
        TabView(selection: $selection) {
            ArticlesListView(title: Constant.mainTitle)
                .tabItem {
                    Label(Tab.today.rawValue, systemImage: Constant.newsPaperImageName)
                }
                .tag(Tab.today)
            
            BookmarkedArticleList(title: Constant.mainTitle, subtitle: Constant.bookmarkSubtitle)
                .tabItem {
                    Label(Tab.bookmarks.rawValue, systemImage: Constant.bookmarkImageName)
                }
                .tag(Tab.bookmarks)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static let source = ArticleSource()
    static var previews: some View {
        HomeView()
            .environmentObject(source)
    }
}
