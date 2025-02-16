//
//  GiveawayRemoteServiceTests.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 15/02/2025.
//


import XCTest
@testable import GamerPowerApp

class GiveawayRemoteServiceTests: XCTestCase {
    var service: GiveawayRemoteService!
    var mockAPIClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        service = GiveawayRemoteService(apiClient: mockAPIClient)
    }

    override func tearDown() {
        service = nil
        mockAPIClient = nil
        super.tearDown()
    }

    func testFetchSuccess() async throws {
        // Given: Mock API response data
        let mockJSON = """
        [
            { "id": 1, "title": "Game 1", "platforms": "PC" },
            { "id": 2, "title": "Game 2", "platforms": "PS5" }
        ]
        """.data(using: .utf8)!
        
        mockAPIClient.mockResult = .success(mockJSON)

        // When: Fetching giveaways
        let giveaways = try await service.fetch(target: .allGiveaways)

        // Then: Validate the response
        XCTAssertEqual(giveaways.count, 2)
        XCTAssertEqual(giveaways[0].title, "Game 1")
        XCTAssertEqual(giveaways[1].platforms, "PS5")
    }

    func testFetchFailure() async {
        // Given: Mock API failure response
        mockAPIClient.mockResult = .failure(APIError.networkError(NSError(domain: "", code: -1, userInfo: nil)))

        do {
            // When: Fetching giveaways
            let _ = try await service.fetch(target: .allGiveaways)
            XCTFail("Expected failure, but got a response")
        } catch let error as APIError {
            XCTAssertNotNil(error)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
