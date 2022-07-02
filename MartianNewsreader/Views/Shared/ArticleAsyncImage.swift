//
//  ArticleImage.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/26/22.
//

import SwiftUI

struct ArticleAsyncImage: View {
    let imageUrl: URL?
    let width: Double
    let maxHeight: Double
    
    enum Constant {
        static let errorImageName = "photo"
    }
    
    init(imageUrl: URL?, width: Double, maxHeight: Double = 200) {
        self.imageUrl = imageUrl
        self.width = width
        self.maxHeight = maxHeight
    }
    
    var body: some View {
        if let url = imageUrl {
            
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    LoadingView(scale: 2.0)
                case .success(let image):
                    image // Displays the loaded image.
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: width, maxHeight: maxHeight)
                        .clipped()
                case .failure:
                    errorImageView
                @unknown default:
                    errorImageView
                }
            }
        } else {
            Image(systemName: Constant.errorImageName)
        }
    }
    
    private var errorImageView: some View {
        Image(systemName: Constant.errorImageName)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: width / 2)
            .foregroundColor(.gray)
            .clipped()
    }
    
    
}

struct ArticleAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        ArticleAsyncImage(imageUrl: Article.sample.topImage?.url, width: 400, maxHeight: 300)
    }
}
