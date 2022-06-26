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
            ArticleRowImage(article: article, width: width)
            VStack(alignment: .leading) {
                Text(article.title)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(Font.system(.title, design: .serif))
                //                .multilineTextAlignment(.center)
                    .padding([.bottom])
                //                .background(Color.blue)
                
                Text(article.body)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                //                .background(Color.pink)
//                // TODO: See if I can make the size of Text view to accommodate the last sentence.
                Spacer()
                    .frame(height: 24)
                Divider()
            }
            .frame(width: (width * 0.90).rounded())
        }
        .padding([.top])
//        .background(Color.gray)
    }
}

struct ArticleRow_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRow(article: Article.sample, width: 380)
    }
}
