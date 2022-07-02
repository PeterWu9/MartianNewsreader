//
//  CurrentDateView.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 6/29/22.
//

import SwiftUI

struct CurrentDateView: View {
    
    var body: some View {
        Text(
            Date()
                .formatted(
                    .dateTime
                        .month()
                        .day()
                )
        )
    }
}

struct CurrentDateView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentDateView()
    }
}
