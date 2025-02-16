//
//  GiveawayViewModel.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 12/02/2025.
//


import Foundation
@MainActor
class GiveawayMasterViewModel: ObservableObject {
    @Published var giveaways: [GiveawayModel] = []
    @Published var errorMessage: String?
    @Published var epicGamesGiveaways: [GiveawayModel] = []
    @Published var searchText: String = ""
    @Published var selectedPlatform: String? = "all"
    @Published private(set) var favoriteIDs: Set<String> = []

    var uniquePlatforms: [String] = ["all", "pc", "steam", "ios", "android"]
    private let favoriteManager = FavoriteManager.shared
    private let repository: GiveawayRepositoryProtocol

    init(repository: GiveawayRepositoryProtocol = GiveawayRepository()) {
         self.repository = repository

        Task {
             let favorites = await favoriteManager.getFavoriteIDs()
             await updateFavoriteIDs(favorites)
         }
     }

    func fetchGiveaways(platform: String? = nil) {
        let repository = self.repository
        Task {
            do {
                var encodedPlatform: String?
                if platform == "all" {
                    encodedPlatform = nil
                } else {
                    encodedPlatform = platform?.replacingOccurrences(of: " ", with: "-")
                }

                let data = try await repository.fetchGiveaways(platform: encodedPlatform)
                await updateGiveaways(data)
            } catch {
                await updateError(error.localizedDescription)
            }
        }
    }

    @MainActor
    private func updateGiveaways(_ data: [GiveawayModel]) async {
        self.giveaways = data
    }

    @MainActor
    private func updateError(_ message: String) async {
        self.errorMessage = message
    }

    @MainActor
    private func updateFavoriteIDs(_ ids: Set<String>) async {
        self.favoriteIDs = ids
    }
    
    var filteredGiveaways: [GiveawayModel] {
        if searchText.isEmpty {
            return giveaways  // Return all giveaways if search is empty
        } else {
            return giveaways.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func selectPlatform(_ platform: String) {
        if selectedPlatform == platform {
            selectedPlatform = nil // Deselect if already selected
        } else {
            selectedPlatform = platform
        }
    }
    
    // Update cached favorites
     func loadFavorites() async {
         favoriteIDs = await favoriteManager.getFavoriteIDs()
     }
     
     func Favorites(_ id: Int) -> Bool {
         return favoriteIDs.contains("\(id)")
     }
     
     // Toggle favorite status and update cached favorites
     func toggleFavorite(_ id: Int) async {
         await favoriteManager.toggleFavorite("\(id)")
         favoriteIDs = await favoriteManager.getFavoriteIDs()
     }
}
