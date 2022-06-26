//
//  ArticleImage.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/26/22.
//

import SwiftUI

struct ArticleRowImage: View {
    let article: Article
    let width: Double
    let height: Double = 200
    
    var body: some View {
        if let url = article.images.first?.url {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image // Displays the loaded image.
                        .resizable()
                    // FIXME: image "fill" doesn't fill
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (width * 0.90).rounded(), height: height)
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

struct ArticleRowImage_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRowImage(article: Article.sample, width: 400)
    }
}
