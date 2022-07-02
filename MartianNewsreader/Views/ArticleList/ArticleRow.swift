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
    
    var body: some View {
        VStack{
            ArticleAsyncImage(
                imageUrl: article.topImage?.url,
                width: width
            )
            
            Text(article.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .lineLimit(nil)
                .font(Font.system(.title, design: .serif))
                .padding([.leading, .bottom, .trailing], 8)
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
