//
//  String+.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/27/22.
//

import Foundation

extension String {
    static let carriage = "\n"
    static let singleQuote = "\'"
    static let doubleQuote = "\""
    static let period = "."
    static let space = " "
    static let paragraph: String = carriage + carriage
    
    var terminatedWithPeriod: Self {
        self + .period
    }
    
    var isGreaterThanThreeCharacters: Bool {
        count > 3
    }
     
    var isNumbers: Bool {
        let numberSet = CharacterSet.decimalDigits.union(CharacterSet.symbols)
        for scalar in self.unicodeScalars {
            if !numberSet.contains(scalar) {
                return false
            }
        }
        return true
    }
    
    // Only relevant if I'm translating to Martian
    var isCapitalized: Bool {
        first?.isUppercase ?? false
    }
}
