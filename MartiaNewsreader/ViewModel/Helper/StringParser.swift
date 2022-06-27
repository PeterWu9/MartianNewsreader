//
//  StringParser.swift
//  TestString
//
//  Created by Peter Wu on 6/27/22.
//

import Foundation

final class StringParser {
    
    static let carriage = "\n"
    static let singleQuote = "\'"
    static let doubleQuote = "\""
    static let paragraph: String = carriage + carriage
    static let terminalCharacters: [Character] = [".", "!", "?", "\""]

    func checkParagraphAndSentenceFragment(for string: String) -> String {
        
        let assemble = checkCarriage(for: string)
        /*
         SENTENCE FRAGMENTS CHECK
         Sentences need to end in one of the terminal character, unless it's a title (which is all caps).
         */
        let whole = assemble.reduce((String(), false)) { partialResult, nextFragment in
            let (previous, previousIsTitle) = partialResult
            
            let nextIsTitle = nextFragment.uppercased() == nextFragment
            // If last fragment was not title, then check if the previous ends in a terminal character.  If the previous did not end in a terminal character, we want to join with the next fragment if next fragment is not title with space rather than paragraph
            if previousIsTitle {
                // Previous is title - join next fragment with paragraph
                // Assertion: No two consecutive fragments are titles
                assert(!nextIsTitle)
                return ([previous, nextFragment].joined(separator: Self.paragraph), false)
            } else {
                // Previous was not a title
                if previous.isEmpty {
                    // Initial iteration - simply join the fragments and go on to the next iteration
                    return ([previous, nextFragment].joined(separator: ""), nextIsTitle)
                } else {
                    // Force unwrap last as previous is not empty
                    if Self.terminalCharacters.contains(previous.last!) {
                        // Previous ends in a terminal character, so it was a proper sentence.  Ok to join with paragraph
                        return ([previous, nextFragment].joined(separator: Self.paragraph), nextIsTitle)
                    } else {
                        // Previous did not end in a terminal character, and not a title, so it was not a proper sentence.
                        // Check next fragment.  If next fragment is a title, then insert period to properly terminate previous, and join with next fragment with paragraph
                        // If next fragment is not a title, then the two fragments are part of a sentence.  Join with next fragment with space
                        if nextIsTitle {
                            let terminated = previous + "."
                            return ([terminated, nextFragment].joined(separator: Self.paragraph), true)
                        } else {
                            return ([previous, nextFragment].joined(separator: " "), false)
                        }
                    }
                }
            }
        }
        
        // Assertion - the writing does not end in title
        // Final check to make sure the last fragment ends with terminal character
        var final = whole.0
        if !final.isEmpty, !Self.terminalCharacters.contains(final.last!) {
            final.append(".")
        }
        
        return final
    }
    
    func checkCarriage(for string: String) -> [String] {
        let parts = string.components(separatedBy: Self.paragraph)
        var assemble = [String]()
        
        for part in parts {
            var newPart = part
            var carriageIndex: String.Index?
            for (index, char) in zip(newPart.indices, newPart) {
                if char == "\n" {
                    carriageIndex = index
                }
            }
            /*
             CARRIAGE CHECK
             If a strangle carriage was found, check:
             - 1: If it's at the start or end of a sentence, it means there were triple carriage characters, and this is an extra one.  Remove the extra carriage character
             - 2: If it's not at the start or end of a sentence, check if the previous character is a punctuation.  If it is a punctuation or quotation, then this was meant to be a paragraph, and we insert an extra carriage character.  If the previous character is not a punctuation or quotation, then this was an carriage inserted in mistake.  Remove the carraige character.
            */
            if let carriageIndex = carriageIndex {
                if carriageIndex == newPart.startIndex || carriageIndex == newPart.endIndex {
                    newPart.remove(at: carriageIndex)
                } else {
                    let previousCharacter = newPart[newPart.index(before: carriageIndex)]
                    
                    if Self.terminalCharacters.contains(previousCharacter) {
                        newPart.insert("\n", at: carriageIndex)
                    } else {
                        newPart.remove(at: carriageIndex)
                    }
                }
            }
            assemble.append(newPart)
        }
        
        return assemble
    }
}




