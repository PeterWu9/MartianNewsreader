import XCTest
@testable import NetworkingLibrary

final class NetworkingLibraryTests: XCTestCase {
    var networkManager: NetworkingManager!
    var testUrl: URL!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkManager = NetworkingManager()
        testUrl = URL(string: "https://www.example.com")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkManager = nil
    }

    func testCreateRequestSuccess() {
        let request = networkManager.create(.get, for: testUrl)
        XCTAssert(request.httpMethod == "GET")
    }
    
    func testResponseSuccess() async throws {
        let (_, response) = try await networkManager.response(.get, for: testUrl)
        let httpResponse = try XCTUnwrap(response as? HTTPURLResponse)
        XCTAssertEqual(httpResponse.statusCode, 200)
    }
    
    func testResponseAndStatusCodeSuccess() async throws {
        let (_, response) = try await networkManager.response(.get, for: testUrl)
        XCTAssertNoThrow(try networkManager.checkResponseAndStatusCode(response))
    }
    
    func testResponseAndStatusCodeFailure() async throws {
        let invalidUrl = URL(string: "https://openlibrary.org/invalid")
        let (_, response) = try await networkManager.response(.get, for: invalidUrl!)
        XCTAssertThrowsError(try networkManager.checkResponseAndStatusCode(response)) { error in
            XCTAssertEqual((error as! NetworkError), NetworkError.invalidNetworkResponse(response: response))
        }
    }
}
