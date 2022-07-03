//
//  ArticleRow.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import SwiftUI

struct ArticleRow: View {
    let article: Article
    let width: Double
    
    private enum Constant {
        static let padding: Double = 8
    }
    
    var body: some View {
        VStack{
            ArticleAsyncImage(
                imageUrl: article.topImage?.url,
                width: width
            )
            ArticleTitleView(
                title: article.title,
                bottomPadding: Constant.padding
            )
            .padding([.leading, .trailing], Constant.padding)
        }
        .padding([.top])
    }
}

struct ArticleRow_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRow(article: Article.sample, width: 380)
            .previewLayout(.fixed(width: 380, height: 300))
    }
}
