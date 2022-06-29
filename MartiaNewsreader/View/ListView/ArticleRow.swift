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
            HStack {
                Spacer()
                    .frame(width: padding)
                ArticleRowImage(article: article, width: width - padding * 2)
                Spacer()
                    .frame(width: padding)
            }
            VStack(alignment: .leading) {
                Text(article.title)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(Font.system(.title, design: .serif))
                    .padding([.bottom])
                
                Text(article.body)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                // TODO: See if I can make the size of Text view to accommodate the last sentence.
                Spacer()
                    .frame(height: 24)
            }
            .frame(width: width - padding * 2)
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
