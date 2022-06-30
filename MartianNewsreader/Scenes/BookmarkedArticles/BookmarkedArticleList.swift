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
    
    var body: some View {
        NavigationView {
            List {
                Text("Bookmark")
                    .font(.system(.headline))
                    .listRowSeparator(.hidden)
                ForEach(articleSource.bookmarkedArticles) { article in
                    HStack {
                        ArticleRowImage(article: article, width: 50, height: 50)
                        Text(article.title)
                    }
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
    static let title = "Bookmark"
    static var previews: some View {
        BookmarkedArticleList(title: title)
            .environmentObject(ArticleSource(reader: ProofReader(), articleService: ArticleService()))
    }
}
