//
//  ArticleRow.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import SwiftUI

struct ArticleRow: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .center) {
            if let url = article.images.first?.url {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image // Displays the loaded image.
//                            .resizable()
                        // FIXME: image "fill" doesn't fill
                            .aspectRatio(contentMode: .fill)
                        //                            .padding()
                            .frame(width: 300, height: 200)
                            .clipped()
                            .background(Color.gray)
                        
                    } else {
                        Color.gray
                            .frame(height: 200)
                    }
                }
            } else {
                // TODO: Generic news headline image
            }
            
            Text(article.title)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .font(Font.system(.title, design: .serif))
                .multilineTextAlignment(.center)
                .padding([.bottom])
//                .background(Color.blue)
            
            Text(article.body)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
//                .background(Color.pink)
            // TODO: See if I can make the size of Text view to accommodate
        }
        .padding([.top])
    }
}

struct ArticleRow_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRow(article: Article.sample)
    }
}
