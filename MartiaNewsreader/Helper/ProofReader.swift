//
//  ProofReader.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/28/22.
//

import Foundation
import ProofReadingLibrary

final class ProofReader: ArticleProofReader {
    func proofRead(_ article: Article) async throws -> String {
        return ProofRead.checkParagraphAndSentenceFragment(for: article.body)
    }
}
