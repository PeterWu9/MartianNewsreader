//
//  ProofReader.swift
//  MartiaNewsreader
//
//  Created by Peter Wu on 6/28/22.
//

import Foundation
import ProofReadingLibrary

protocol ArticleProofReader {
    init()
    // Proof reading may be an asynchronous operation (could be services performed over network or a potentially long-running background operation)
    func proofRead(_ article: Article) async throws -> String
}


final class ProofReader: ArticleProofReader {
    func proofRead(_ article: Article) async throws -> String {
        return ProofRead.checkParagraphAndSentenceFragment(for: article.body)
    }
}
