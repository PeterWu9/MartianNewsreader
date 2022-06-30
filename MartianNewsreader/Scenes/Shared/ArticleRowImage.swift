//
//  ArticleImage.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/26/22.
//

import SwiftUI

struct ArticleAsyncImage: View {
    let article: Article
    let width: Double
    let height: Double
    
    init(article: Article, width: Double, height: Double = 200) {
        self.article = article
        self.width = width
        self.height = height
    }
    
    var body: some View {
        if let url = article.topImage?.url {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image // Displays the loaded image.
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                        .clipped()
                        .background(Color.gray)
                } else {
                    Color.gray
                        .frame(height: height)
                }
            }
        } else {
            // TODO: Generic news headline image
        }
    }
}

struct ArticleAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        ArticleAsyncImage(article: Article.sample, width: 400)
    }
}
