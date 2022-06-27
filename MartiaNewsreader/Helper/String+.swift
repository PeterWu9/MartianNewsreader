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
}
