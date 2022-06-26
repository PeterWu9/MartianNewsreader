//
//  ArticlesListView.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import SwiftUI

struct ArticlesListView: View {
    
    @EnvironmentObject var articlesFetcher: ArticlesFetcher
    @State var isLoadingArticles: Bool = false

    var body: some View {
        VStack {
            if isLoadingArticles {
                ProgressView()
                    .scaleEffect(.init(3.0), anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: .pink))
            } else {
                List {
                    ForEach(articlesFetcher.articles) { article in
                        ArticleRow(article: article)
                            .padding([.bottom])
                    }
                }
            }
        }
        .task {
            isLoadingArticles = true
            do {
                try await articlesFetcher.fetchArticles()
                isLoadingArticles = false
            } catch {
                // TODO: Show error view
                isLoadingArticles = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesListView()
            .environmentObject(ArticlesFetcher())
    }
}

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}
