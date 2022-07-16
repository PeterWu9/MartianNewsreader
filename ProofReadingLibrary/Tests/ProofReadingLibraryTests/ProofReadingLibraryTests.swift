import XCTest
@testable import ProofReadingLibrary

final class ProofReadingLibraryTests: XCTestCase {
    let singleSentenceWithNumbers = "20,000 Leagues Under the Sea"
    let singleWordWithEmbeddedNumber = "fri3nd"
    let singleSentenceCapitalized = "Is there life on Mars?"
    
    func testSingleSentenceWithNumbers() throws {
        let translation = ProofRead.translateToMartian(for: singleSentenceWithNumbers)
        XCTAssert(translation == "20,000 Boinga Boinga the Sea")
    }
    
    func testSingleWordWithEmbeddedNumber() throws {
        let translation = ProofRead.translateToMartian(for: singleWordWithEmbeddedNumber)
        XCTAssert(translation == "boinga")
    }
    
    func testSingleSentenceCapitalized() throws {
        let translation = ProofRead.translateToMartian(for: singleSentenceCapitalized)
        XCTAssert(translation == "Is boinga boinga on Boinga?")
    }
}
