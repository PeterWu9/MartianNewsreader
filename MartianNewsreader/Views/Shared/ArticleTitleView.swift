//
//  ArticleTitleView.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 7/2/22.
//

import SwiftUI

struct ArticleTitleView: View {
    let title: String
    let bottomPadding: Double
    
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .lineLimit(nil)
            .font(Font.system(.title, design: .serif))
            .padding([.bottom], bottomPadding)
    }
}

struct ArticleTitleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleTitleView(title: "Test", bottomPadding: 0)
    }
}
