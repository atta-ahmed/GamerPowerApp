//
//  GiveawayMasterViewModelTests.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 15/02/2025.
//


import XCTest
@testable import GamerPowerApp

class GiveawayMasterViewModelTests: XCTestCase {
    var viewModel: GiveawayMasterViewModel!
    var mockRepository: MockGiveawayRepository!

    override func setUp() async throws {
        try await super.setUp()
        mockRepository = MockGiveawayRepository()
        viewModel = await GiveawayMasterViewModel(repository: mockRepository)
    }

    override func tearDown() async throws {
        viewModel = nil
        mockRepository = nil
        try await super.tearDown()
    }

    func testFetchGiveawaysSuccess() async {
        // Given
        let mockData: [GiveawayModel] = [
            GiveawayModel(id: 1, title: "Free Game 1"),
            GiveawayModel(id: 2, title: "Epic Game 2")
        ]
        mockRepository.result = .success(mockData)

        // When
        let expectation = expectation(description: "Wait for giveaways to load")

        // When
        Task {
            await viewModel.fetchGiveaways()
            expectation.fulfill()
        }

        // Then: Wait for the async task to complete before asserting
        await fulfillment(of: [expectation], timeout: 2.0)

        let giveaways = await MainActor.run { viewModel.giveaways }
        // Then
        XCTAssertEqual(giveaways.count, 2)
        XCTAssertEqual(giveaways.first?.title, "Free Game 1")
    }

    func testFetchGiveaways_Failure() async {
        // Given
        mockRepository.result = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"]))

        // When
        // When
        let expectation = expectation(description: "Wait for giveaways to load")

        // When
        Task {
            await viewModel.fetchGiveaways()
            expectation.fulfill()
        }

        // Then: Wait for the async task to complete before asserting
        await fulfillment(of: [expectation], timeout: 2.0)

        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.errorMessage, "Network error")
        }
    }

    @MainActor func testFilteredGiveawaysWhenSearchTextMatches() {
        // Given
        viewModel.giveaways = [
            GiveawayModel(id: 1, title: "Free Game 1"),
            GiveawayModel(id: 2, title: "Epic Game 2"),
            GiveawayModel(id: 3, title: "Other Game")
        ]
        viewModel.searchText = "epic"

        // When
        let filtered = viewModel.filteredGiveaways

        // Then
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.title, "Epic Game 2")
    }

    @MainActor func testFilteredGiveawaysWhenSearchTextIsEmpty() {
        // Given
        viewModel.giveaways = [
            GiveawayModel(id: 1, title: "Free Game 1"),
            GiveawayModel(id: 2, title: "Epic Game 2")
        ]
        viewModel.searchText = ""

        // When
        let filtered = viewModel.filteredGiveaways

        // Then
        XCTAssertEqual(filtered.count, 2)
    }

    @MainActor func testSelectPlatform() async {
        // Given
        XCTAssertEqual(viewModel.selectedPlatform, "all")

        // When
        viewModel.selectPlatform("pc")

        // Then
        XCTAssertEqual(viewModel.selectedPlatform, "pc")

        // When selecting the same platform again
        viewModel.selectPlatform("pc")

        // Then it should be deselected
        XCTAssertNil(viewModel.selectedPlatform)
    }
}

// MARK: - Mock Repository
class MockGiveawayRepository: GiveawayRepositoryProtocol {
    var result: Result<[GiveawayModel], Error> = .success([])

    func fetchGiveaways(platform: String?) async throws -> [GiveawayModel] {
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}
