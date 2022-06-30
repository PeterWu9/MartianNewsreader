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
    let maxHeight: Double
    
    enum Constant {
        static let errorImageName = "photo"
    }
    
    init(article: Article, width: Double, maxHeight: Double = 200) {
        self.article = article
        self.width = width
        self.maxHeight = maxHeight
    }
    
    var body: some View {
        if
            let articleImage = article.topImage,
            let url = articleImage.url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image // Displays the loaded image.
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: width, maxHeight: maxHeight)
                        .clipped()
                case .failure:
                    Image(systemName: Constant.errorImageName)
                @unknown default:
                    Image(systemName: Constant.errorImageName)
                }
            }
        } else {
            // TODO: Generic news headline image
            Image(systemName: Constant.errorImageName)
        }
    }
}

struct ArticleAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        ArticleAsyncImage(article: Article.sample, width: 400, maxHeight: 300)
    }
}
