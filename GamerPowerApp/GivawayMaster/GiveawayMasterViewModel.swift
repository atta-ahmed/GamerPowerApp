//
//  GiveawayViewModel.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 12/02/2025.
//

import Foundation

@MainActor
class GiveawayMasterViewModel: ObservableObject {
    @Published var giveaways: [GiveawayUIModel] = []
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var selectedPlatform: Platform? = .all
    @Published private(set) var favoriteIDs: Set<String> = []
    
    private let favoriteManager = FavoriteManager.shared
    private let repository: GiveawayRepositoryProtocol
    private var hasFetchedData = false
    
    // For platforms horizontal scroll
    var uniquePlatforms: [Platform] = Platform.allCases

    // Search
    var filteredGiveaways: [GiveawayUIModel] {
        searchText.isEmpty ? giveaways :
        giveaways.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    init(repository: GiveawayRepositoryProtocol = GiveawayRepository()) {
        self.repository = repository
    }

    // MARK: - Fetch and handle UI
    // Prevent unnecessary re-fetches
    func fetchGiveawaysIfNeeded() {
        guard !hasFetchedData else { return }
        hasFetchedData = true
        fetchGiveaways()
    }
    
    func fetchGiveaways(platform: Platform = .all) {
        let repository = self.repository
        Task {
            do {
                let data = try await repository.fetchGiveaways(platform: platform)
                await updateGiveaways(data)
            } catch {
                await updateError(error.localizedDescription)
            }
        }
    }
    private func updateGiveaways(_ data: [GiveawayModel]) async {
        giveaways = data.map { GiveawayUIModel(from: $0) }
    }

    private func updateError(_ message: String) async {
        errorMessage = message
    }
    
    func selectPlatform(_ platform: Platform) {
        if selectedPlatform != platform {
            selectedPlatform = platform
        }
    }
    
    // MARK: - Favorites
    func loadFavorites() {
        Task {
            await updateFavoriteIDs(await favoriteManager.getFavoriteIDs())
        }
    }

    private func updateFavoriteIDs(_ ids: Set<String>) async {
        favoriteIDs = ids
    }

    // Toggle favorite status and update cached favorites
    func toggleFavorite(_ id: Int) {
        Task {
            await favoriteManager.toggleFavorite("\(id)")
            await updateFavoriteIDs(await favoriteManager.getFavoriteIDs())
        }
    }
    
    // Update cached favorites
     func loadFavorites() async {
         favoriteIDs = await favoriteManager.getFavoriteIDs()
     }
     
     func isFavorite(_ id: Int) -> Bool {
         return favoriteIDs.contains("\(id)")
     }
    
}

// MARK: - Helpers
extension GiveawayMasterViewModel {

    // Group giveaways by platforms
    func groupGiveawaysByPlatform() -> [String: [GiveawayUIModel]] {
        var groupedGiveaways: [String: [GiveawayUIModel]] = [:]

        for giveaway in giveaways {
            for platform in giveaway.platformArray ?? [] {
                groupedGiveaways[platform, default: []].append(giveaway)
            }
        }
        return groupedGiveaways
    }

}
