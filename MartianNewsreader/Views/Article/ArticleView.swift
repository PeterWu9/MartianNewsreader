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
    @State private var isBookmarked: Bool = false
    
    private enum Constant {
        static let bottomPadding: Double = 0
        static let imageBottomSpaceHeight: Double = 24
        static let imageWidthScale: Double = 0.9
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    ArticleTitleView(
                        title: article.title,
                        bottomPadding: Constant.bottomPadding
                    )
                    ArticleAsyncImage(
                        imageUrl: article.topImage?.url,
                        width: geometry.size.width * Constant.imageWidthScale
                    )
                    Spacer()
                        .frame(height: Constant.imageBottomSpaceHeight)
                    
                    Text(article.body)
                }
                .padding([.leading, .trailing])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // If bookmark operation does not succeed, user will know because the button image won't change
                        Task {
                            do {
                                try await source.bookmarkTapped(on: article)
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Image(systemName: article.isBookmarked ? "bookmark.fill" : "bookmark")
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
