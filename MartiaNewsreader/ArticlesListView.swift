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
    
    let scale: Double = 3.0
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    if isLoadingArticles {
                        ProgressView()
                            .scaleEffect(.init(scale), anchor: .center)
                            .progressViewStyle(CircularProgressViewStyle(tint: .pink))
                    } else {
                        ForEach(articlesFetcher.articles) { article in
                            ArticleRow(article: article, width: geometry.size.width)
                                .padding([.bottom])
                        }
                        .navigationTitle("Martian News")
//                        .background(Color.pink)
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ArticlesListView()
                .environmentObject(ArticlesFetcher())
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
            ArticlesListView()
                .environmentObject(ArticlesFetcher())
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        }
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
