//
//  ArticleView.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/26/22.
//

import SwiftUI

struct ArticleView: View {
    
    let article: Article
    
    @EnvironmentObject var source: ArticleSource
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Text(article.title)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .lineLimit(nil)
                        .font(Font.system(.title, design: .serif))
                        .padding([.bottom])
                    
                    ArticleAsyncImage(imageUrl: article.topImage?.url, width: geometry.size.width * 0.9 )
                    Spacer()
                        .frame(height: 24)
                    Text(article.body)
                }
                .padding([.leading, .trailing])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // If bookmark operation does not succeed, user will know because the button image won't change
                        Task {
                            try? await source.bookmarkButtonTapped(on: article)
                        }
                    } label: {
                        Image(systemName: source.isBookmarked(for: article) ? "bookmark.fill" : "bookmark")
                    }
                }
            }
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: Article.sample)
    }
}
