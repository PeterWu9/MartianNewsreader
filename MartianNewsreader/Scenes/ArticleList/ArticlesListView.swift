//
//  ArticlesListView.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import SwiftUI

struct ArticlesListView: View {
    
    @EnvironmentObject var articlesFetcher: ArticleSource<ProofReader, ArticleService>
    
    let title: String
    
    private enum Constant {
        static let scale: Double = 3.0
        static let padding: Double = 24.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                List {
                    switch articlesFetcher.loadingState {
                        
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
                        
                        ForEach(articlesFetcher.articles) { article in
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
                                            .environmentObject(articlesFetcher)
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
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        TitleView(title: title)
                    }
                }
            }
        }
    }
}

struct ArticlesListView_Previews: PreviewProvider {
    static let title = "Today's News"
    static var previews: some View {
        Group {
            ArticlesListView(title: Self.title)
                .environmentObject(ArticleSource(reader: ProofReader(), articleService: ArticleService()))
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
            ArticlesListView(title: Self.title)
                .environmentObject(ArticleSource(reader: ProofReader(), articleService: ArticleService()))
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        }
    }
}
