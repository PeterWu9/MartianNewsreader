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
    let padding: Double
    
    var body: some View {
        VStack{
            ArticleRowImage(article: article, width: width)

            Text(article.title)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .font(Font.system(.title, design: .serif))
                .padding([.bottom])
        }
        .padding([.top])
    }
}

struct ArticleRow_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRow(article: Article.sample, width: 380, padding: 24)
            .previewLayout(.fixed(width: 380, height: 450))
    }
}
