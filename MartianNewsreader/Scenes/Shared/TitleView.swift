//
//  TitleView.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/27/22.
//

import SwiftUI

struct TitleView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .fontWeight(.bold)
            .font(.system(.title, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: [.red, .pink, .indigo],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(title: "Martian News")
    }
}
