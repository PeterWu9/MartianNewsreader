//
//  BookmarkedArticleList.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/29/22.
//

import SwiftUI

struct BookmarkedArticleList: View {
    
    @EnvironmentObject var articleSource: ArticleSource<ProofReader, ArticleService>
    let title: String
    let subtitle: String
    
    var body: some View {
        NavigationView {
            List {
                Text(subtitle)
                    .font(.system(.headline))
                    .listRowSeparator(.hidden)
                ForEach(articleSource.bookmarkedArticles) { article in
                    HStack {
                        ArticleAsyncImage(article: article, width: 50, height: 50)
                        Text(article.title)
                    }
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

struct BookmarkedArticleList_Previews: PreviewProvider {
    static let title = "Martian News"
    static let subtitle = "Bookmarks"
    static var previews: some View {
        BookmarkedArticleList(title: title, subtitle: subtitle)
            .environmentObject(
                ArticleSource(
                    reader: ProofReader(),
                    articleService: ArticleService()
                )
            )
    }
}