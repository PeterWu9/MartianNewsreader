//
//  NewsFetcher.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/25/22.
//

import Foundation

@MainActor
final class ArticlesFetcher: ObservableObject {
    
    @Published private(set) var articles: Articles = []
        
    func fetchArticles() async throws {
        
        let fetchedArticles = try await NetworkManager.shared.getArticles()
        self.articles = fetchedArticles.map { checkCarriageAndSentenceFragment(for: $0) }
    }
    
    func checkCarriageAndSentenceFragment(for article: Article) -> Article {
        
        return Article(
            title: article.title,
            images: article.images,
            body: StringParser.checkParagraphAndSentenceFragment(for: article.body)
        )
    }
}

extension ArticlesFetcher {
    
    enum StringParser {
        
        /// This function checks and fixes a string to make sure the paragraphs and sentences are separated by the proper characters/string.  This function only works when the input string is composed of paragraphs separated by two carriage characters, and each sentence, with the exception of a title sentence, is terminated by a period or quotation mark.
        static func checkParagraphAndSentenceFragment(for string: String) -> String {
            
            let paragraphs = checkParagraphSeparator(for: string)
            /*
             The reduce algorithm below assembles the paragraphs to make sure the paragraphs and sentences are separated by the proper characters.  For each paragraph, two states are maintained:
             - The assembled paragraphs up to the current iteration
             - If the previous paragraph is a title sentence.  When a sentence is a title sentence, it does not have to end by a terminal character.  This state is important in helping the algorithm to choosing the rules to properly combine the accumulated paragraphs with the next sentence
             */
            var (articleBody, _) = paragraphs.reduce((String(), false)) { accumulated, nextSentence in
                
                let (previousParagraphs, previousSentenceIsTitle) = accumulated
                let nextSentenceIsTitle = nextSentence.uppercased() == nextSentence
                
                if previousSentenceIsTitle {
                    /*
                     If the previous sentence is a title sentence, it is safe to join with the next sentence with paragraph separator
                     Assumption: the paragraph does not contain two consecutive title sentences
                     */
                    assert(!nextSentenceIsTitle)
                    return ([previousParagraphs, nextSentence].joined(separator: .paragraph), false)
                    
                } else {
                    /* If last sentence is not a title sentence, then the last paragraph needs to be checked for proper sentence termination.
                        - If the last paragraph ended properly, then it's safe to combine with the next sentence, and continue with the next iteration.
                        - If the last paragraph did not end properly, then inspect the next sentence's status, with two possible outcomes:
                            - 1. the next sentence is a title sentence. In this case, the previous sentence was indeed a sentence, with the terminating character missing. Fix the previous sentence by appending the default terminating character "." to the accumulated paragraph, and combine with the title sentence with paragraph separator
                            - 2. the next sentence is not a title sentence.  In this case, the next sentence is a continuation of the previous sentence, and the two is to be combined with a space separator.
                     */
                    guard let lastChar = previousParagraphs.last else {
                        // Accumulated string is empty, which indicates we're in the initial iteration. Move on to next iteration
                        return (nextSentence, nextSentenceIsTitle)
                    }

                    if lastChar.isTerminalCharacter {
                        return ([previousParagraphs, nextSentence].joined(separator: .paragraph), nextSentenceIsTitle)
                        
                    } else {
                        if nextSentenceIsTitle {
                            let terminated = previousParagraphs.terminatedWithPeriod
                            return ([terminated, nextSentence].joined(separator: .paragraph), true)
                        } else {
                            return ([previousParagraphs, nextSentence].joined(separator: .space), false)
                        }
                    }
                }
            }
            
            // Assumption - the article body does not end with a title sentence
            // Final check to make sure the last sentence ends with terminal character
            if
                let lastChar = articleBody.last,
                !lastChar.isTerminalCharacter
            {
                articleBody.append(.period)
            }
            
            return articleBody
        }
        
        /// This function takes a string and fix any paragraph separator that isn't two carriage characters
        static func checkParagraphSeparator(for string: String) -> [String] {
            
            let parts = string.components(separatedBy: String.paragraph)
            var assembled = [String]()
            
            for part in parts {
                var newPart = part
                var carriageIndex: String.Index?
                
                for (index, char) in zip(newPart.indices, newPart) {
                    if char == Character(.carriage) {
                        carriageIndex = index
                    }
                }
                /*
                 SEPARATOR CHECK
                 If a single carriage character was found, check:
                 - 1: if the character is at the start or end of a sentence, it means there were triple carriage characters, and this is the extra.  Remove the extra.
                 - 2: if the character is not at the start or end of a sentence, check if the previous character is a sentence terminal character.  If the previous character is a terminal character, then this sentence was meant to be a paragraph.  Fix the separator by inserting an extra carriage.  If the previous character is not a terminal character, then this was an invalid carriage character.  Fix the sentence by removing the carriage.
                */
                if let carriageIndex = carriageIndex {
                    if carriageIndex == newPart.startIndex || carriageIndex == newPart.endIndex {
                        newPart.remove(at: carriageIndex)
                        
                    } else {
                        let previousCharacter = newPart[newPart.index(before: carriageIndex)]
                        
                        if previousCharacter.isTerminalCharacter {
                            newPart.insert(Character(.carriage), at: carriageIndex)
                            
                        } else {
                            newPart.remove(at: carriageIndex)
                        }
                    }
                }
                assembled.append(newPart)
            }
            return assembled
        }
    }
}
