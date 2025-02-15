//
//  APIClientTests.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 15/02/2025.
//
import XCTest
@testable import GamerPowerApp

class APIClientTests: XCTestCase {
    var apiClient: APIClientMock!

    override func setUp() {
        super.setUp()
        apiClient = APIClientMock()
    }

    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }

    func testRequest_Success() async throws {
        // Given: Mock a successful API response
        let expectedData = """
        [
            {
                "id": 1,
                "title": "Test Giveaway"
            }
        ]
        """.data(using: .utf8)!

        APIClientMock.stubbedResponse = .success(expectedData)

        // When
        let result: [GiveawayModel] = try await apiClient.request(GiveawayAPI.allGiveaways)

        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "Test Giveaway")
    }

    func testRequest_Failure() async {
        // Given: Simulate an API failure
        APIClientMock.stubbedResponse = .failure(NSError(domain: "API Error", code: 500))

        do {
            // When
            let _: [GiveawayModel] = try await apiClient.request(GiveawayAPI.allGiveaways)
            XCTFail("Expected failure but got success")
        } catch {
            // Then
            XCTAssertNotNil(error)
        }
    }
}

// ✅ Mock API Client
class APIClientMock: APIClientProtocol {

    static var stubbedResponse: Result<Data, Error>?

    func request<T: Decodable>(_ urlRequest: URLRequest) async throws -> T {
        switch APIClientMock.stubbedResponse {
        case .success(let data):
            return try JSONDecoder().decode(T.self, from: data)
        case .failure(let error):
            throw error
        case .none:
            throw APIError.unknown
        }
    }
}

protocol MockTargetType {
    var mockURL: URL { get }
}
