//
//  APIClientTests.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 15/02/2025.
//
import XCTest
@testable import GamerPowerApp

class APIClientTests: XCTestCase {
    var apiClient: APIClient!

    override func setUp() {
        super.setUp()
        apiClient = APIClient() // Using the real APIClient but with a dummy request
    }

    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }

    func testRequest_Success() async throws {
        // Given: A dummy request
        let dummyURL = URL(string: "https://example.com/dummy")!
        var request = URLRequest(url: dummyURL)
        request.httpMethod = "GET"

        struct DummyResponse: Decodable {
            let message: String
        }

        // When: Making the request
        do {
            let _: DummyResponse = try await apiClient.request(request)
            XCTFail("Expected failure due to no network, but got a response")
        } catch {
            // Then: Expecting a network failure
            XCTAssertNotNil(error, "Error should not be nil")
        }
    }
}

class MockAPIClient: APIClientProtocol {
    var mockResult: Result<Data, Error>?

    func request<T: Decodable & Sendable>(_ request: URLRequest) async throws -> T {
        guard let result = mockResult else {
            throw APIError.networkError(NSError(domain: "Mock", code: -1, userInfo: nil))
        }

        switch result {
        case .success(let data):
            return try JSONDecoder().decode(T.self, from: data)
        case .failure(let error):
            throw error
        }
    }
}

