//
//  BookmarkedArticleList.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/29/22.
//

import SwiftUI

struct BookmarkedArticleList: View {
    
    @EnvironmentObject var source: ArticleSource
    let title: String
    let subtitle: String
    private let imageWidth = 50.0
    private let imageCornerRadius = 5.0
    
    var body: some View {
        NavigationView {
            List {
                Text(subtitle)
                    .font(.system(.headline))
                    .listRowSeparator(.hidden)
                ForEach(source.bookmarkedArticles) { article in
                    HStack {
                        ArticleAsyncImage(
                            imageUrl: article.topImage?.url,
                            width: imageWidth, maxHeight: imageWidth
                        )
                        .cornerRadius(imageCornerRadius)
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
            .listTitleStyle(title: title)
        }
    }
}

struct BookmarkedArticleList_Previews: PreviewProvider {
    static let source = ArticleSource()
    static let title = "Martian News"
    static let subtitle = "Bookmarks"
    static var previews: some View {
        BookmarkedArticleList(title: title, subtitle: subtitle)
            .environmentObject(source)
    }
}
