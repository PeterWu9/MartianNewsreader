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
    
    private let scale: Double = 3.0
    private let padding: Double = 24.0
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                if isLoadingArticles {
                    ProgressView()
                        .scaleEffect(.init(scale), anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: .pink))
                } else {
                    List {
                        ForEach(articlesFetcher.articles) { article in
                            ArticleRow(
                                article: article,
                                width: geometry.size.width * 0.9,
                                padding: padding
                            )
                            // Enables navigation to article detail view but hides the disclosure button
                            .overlay(
                                NavigationLink(
                                    destination: { ArticleView(article: article) },
                                    label: { EmptyView() }
                                )
                                .opacity(0)
                            )
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            HStack {
                                Spacer()
                                    .frame(width: padding)
                                TitleView()
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationViewStyle(.stack)
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
