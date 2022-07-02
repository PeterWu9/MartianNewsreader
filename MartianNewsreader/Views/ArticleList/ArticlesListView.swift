//
//  ArticlesListView.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import SwiftUI

struct ArticlesListView: View {
    
    @EnvironmentObject var source: ArticleSource
    
    let title: String
    
    private enum Constant {
        static let scale: Double = 3.0
        static let padding: Double = 24.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                List {
                    switch source.loadingState {
                        
                    case .isLoading:
                        Spacer()
                            .frame(height: Constant.padding)
                        LoadingView(scale: Constant.scale)
                        .listRowSeparator(.hidden)
                        
                    case .completeLoading:
                        CurrentDateView()
                            .font(.system(.headline))
                            .listSectionSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .padding([.leading])
                        
                        ForEach(source.articles) { article in
                            ArticleRow(
                                article: article,
                                width: geometry.size.width
                            )
                            .padding([.bottom])
                            
                            .listRowInsets(EdgeInsets())
                            // Enables navigation to article detail view but hides the disclosure button
                            .overlay(
                                NavigationLink(
                                    destination: {
                                        ArticleView(article: article)
                                    },
                                    label: { EmptyView() }
                                )
                                .opacity(0)
                            )
                        }
                        
                    case .hasLoadingError(let error):
                        // TODO: Add description for pull to refresh to try again
                        Spacer()
                        HStack {
                            Spacer()
                            LoadingErrorView(error: error)
                                .padding()
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                    }
                }
                .listTitleStyle(title: title)
                .onAppear {
                    UIRefreshControl.appearance().tintColor = .systemPink
                }
                .refreshable(action: {
                    try? await source.fetchArticles()
                })
                .task {
                    try? await source.fetchArticles()
                }

            }
        }
    }
}

struct ArticlesListView_Previews: PreviewProvider {
    static let source = ArticleSource()
    static let title = "Today's News"
    static var previews: some View {
        Group {
            ArticlesListView(title: Self.title)
                .environmentObject(source)
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
            ArticlesListView(title: Self.title)
                .environmentObject(source)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        }
    }
}
