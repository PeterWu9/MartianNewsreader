//
//  TransparentNavigationOverlayModifier.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 7/2/22.
//

import SwiftUI

struct TransparentNavigationOverlayModifier<Item: Identifiable, Destination: View>: ViewModifier {
    
    private let item: Item
    private let destination: (Item) -> Destination
    
    init(item: Item, @ViewBuilder content: @escaping (Item) -> Destination) {
        self.item = item
        self.destination = content
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                NavigationLink(
                    destination: {
                        destination(item)
                    },
                    label: { EmptyView() }
                )
                .opacity(0)
            )
    }
}
