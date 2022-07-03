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
    private let previous: String
    
    init(previous: String, item: Item, @ViewBuilder content: @escaping (Item) -> Destination) {
        self.previous = previous
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
                .navigationTitle(previous)
                .opacity(0)
            )
    }
}
