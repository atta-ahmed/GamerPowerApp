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

    override func setUp() {
        super.setUp()
        mockRepository = MockGiveawayRepository()
        viewModel = GiveawayMasterViewModel(repository: mockRepository)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    func testFetchGiveaways_Success() async {
        // Given
        let mockData = [
            GiveawayModel(id: 1, title: "Free Game 1"),
            GiveawayModel(id: 2, title: "Epic Game 2")
        ]
        mockRepository.result = .success(mockData)

        // When
        await viewModel.fetchGiveaways()

        // Then
        XCTAssertEqual(viewModel.giveaways.count, 2)
        XCTAssertEqual(viewModel.giveaways.first?.title, "Free Game 1")
        XCTAssertNil(viewModel.errorMessage)
    }

    func testFetchGiveaways_Failure() async {
        // Given
        mockRepository.result = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"]))

        // When
        await viewModel.fetchGiveaways()

        // Then
        XCTAssertEqual(viewModel.giveaways.count, 0)
        XCTAssertEqual(viewModel.errorMessage, "Network error")
    }

    func testFilteredGiveaways_WhenSearchTextMatches() {
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

    func testFilteredGiveaways_WhenSearchTextIsEmpty() {
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

    func testSelectPlatform() async {
        // Given
        XCTAssertEqual(viewModel.selectedPlatform, "all")

        // When
        await viewModel.selectPlatform("pc")

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
