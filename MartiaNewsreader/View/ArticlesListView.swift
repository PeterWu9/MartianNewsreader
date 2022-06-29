//
//  ArticlesListView.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import SwiftUI

struct ArticlesListView: View {
    
    enum LoadingState {
        case isLoading
        case completeLoading
        case hasLoadingError(Error)
    }
    
    @EnvironmentObject var articlesFetcher: ArticleSource<ProofReader, ArticleService>
    @State var loadingState: LoadingState = .isLoading
    
    private let scale: Double = 3.0
    private let padding: Double = 24.0
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                switch loadingState {
                case .isLoading:
                    ProgressView()
                        .scaleEffect(.init(scale), anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: .pink))
                case .completeLoading:
                    List {
                        CurrentDateView()
                            .listRowSeparator(.hidden)
                        ForEach(articlesFetcher.articles) { article in
                            ArticleRow(
                                article: article,
                                width: geometry.size.width,
                                padding: padding
                            )
                            .listRowInsets(EdgeInsets())
                            // Enables navigation to article detail view but hides the disclosure button
                            .overlay(
                                NavigationLink(
                                    destination: {
                                        ArticleView(article: article)
                                            .environmentObject(articlesFetcher)
                                    },
                                    label: { EmptyView() }
                                )
                                .opacity(0)
                                .navigationTitle("")
                            )
                        }
                    }
                    .listStyle(.plain)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            TitleView()
                        }
                    }
                case .hasLoadingError(let error):
                    // TODO: Add description for pull to refresh to try again
                    VStack {
                        LoadingErrorView(error: error)
                            .padding()
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .principal) {
                                    TitleView()
                                }
                            }
                        Spacer()
                    }
                }
            }
            .task {
                loadingState = .isLoading
                do {
                    try await articlesFetcher.fetchArticles()
                    loadingState = .completeLoading
                } catch {
                    loadingState = .hasLoadingError(error)
                }
            }
        }
    }
}

struct ArticlesListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ArticlesListView()
                .environmentObject(ArticleSource(reader: ProofReader(), articleService: ArticleService()))
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
            ArticlesListView()
                .environmentObject(ArticleSource(reader: ProofReader(), articleService: ArticleService()))
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        }
    }
}
