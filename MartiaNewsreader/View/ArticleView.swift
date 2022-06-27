//
//  ArticleView.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/26/22.
//

import SwiftUI

struct ArticleView: View {
    let article: Article
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Text(article.title)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(Font.system(.title, design: .serif))
                        .padding([.bottom])

                    if let url = article.images.first?.url {
                        AsyncImage(url: url) { phase in
                            if let image = phase.image {
                                image // Displays the loaded image.
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.9)
                                    .clipped()
                            } else {
                                Color.gray
                            }
                        }
                    } else {
                        // TODO: Generic news headline image
                    }
                    Spacer()
                        .frame(height: 24)
                    Text(article.body)
                }
                .padding([.leading, .trailing])
            }
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: Article.sample)
    }
}
