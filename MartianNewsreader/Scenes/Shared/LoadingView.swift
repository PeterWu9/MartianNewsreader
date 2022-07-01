//
//  LoadingView.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/30/22.
//

import SwiftUI

struct LoadingView: View {
    let scale: Double
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            ProgressView()
                .scaleEffect(.init(scale), anchor: .center)
                .progressViewStyle(CircularProgressViewStyle(tint: .pink))
            Spacer()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(scale: 1.0)
    }
}
