//
//  Character+.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/27/22.
//

import Foundation

extension Character {
    static let terminalCharacters: [Self] = [".", "!", "?", "\""]

    var isTerminalCharacter: Bool {
        Self.terminalCharacters.contains(self)
    }
}
