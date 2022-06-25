//
//  ArticlesListView.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import SwiftUI

struct ArticlesListView: View {
    
    @EnvironmentObject var newsFetcher: NewsFetcher
    @State var isLoadingArticles: Bool = false

    var body: some View {
        VStack {
            if isLoadingArticles {
                ProgressView()
                    .scaleEffect(.init(3.0), anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: .pink))
            } else {
                List {
                    ForEach(newsFetcher.articles) { article in
                        VStack {
                            Text("Image View")
                            Text("Title")
                            Text(article.title)
                        }
                    }
                }
            }
        }
        .task {
            isLoadingArticles = true
            do {
                try await newsFetcher.fetchArticles()
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
