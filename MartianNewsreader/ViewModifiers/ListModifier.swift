//
//  ListModifier.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 7/2/22.
//

import SwiftUI

struct ListTitleModifier: ViewModifier {
    private let title: String
    
    init(title: String) {
        self.title = title
    }
    
    func body(content: Content) -> some View {
        content
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TitleView(title: title)
                }
            }
    }
}

