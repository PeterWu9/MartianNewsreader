//
//  View+.swift
//  MartianNewsreader
//
//  Created by Peter Wu on 7/2/22.
//

import SwiftUI

extension View {
    func listTitleStyle(title: String) -> some View {
        modifier(ListTitleModifier(title: title))
    }
}