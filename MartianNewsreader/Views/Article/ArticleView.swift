//
//  ArticleView.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/26/22.
//

import SwiftUI

struct ArticleView: View {
    
    let article: Article
    @State private var isShowingError = false
    @EnvironmentObject var source: ArticleSource
    
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
                .confirmationDialog("Error", isPresented: $isShowingError) {
                    Text("Sorry - we ran into issue while saving/unsaving bookmark")
                    Button("Ok") {
                        isShowingError = false
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // If bookmark operation does not succeed, user will know because the button image won't change
                        Task {
                            do {
                                try await source.bookmarkButtonTapped(on: article)
                            } catch {
                                isShowingError = true
                            }
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
