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
    private let favoriteManager = FavoriteManager.shared
    @Published private(set) var favoriteIDs: Set<String> = []

    var uniquePlatforms: [String] = ["all", "pc", "steam", "ios", "android"]
    
    private let apiService: APIServiceProtocol
    

 
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
        
        Task {
            await favoriteIDs = favoriteManager.getFavoriteIDs()
        }
    }
    
    func fetchGiveaways(platform: String? = nil) {
        let apiService = self.apiService

        Task {
            do {
                let target: GiveawayAPI
                if let platform = platform?.lowercased(), platform != "all" {
                    target = .giveawaysByPlatform(platform: platform)
                } else {
                    target = .allGiveaways
                }

                let data: [GiveawayModel] = try await apiService.request(target)
                print("=======> self.data = ", data.first?.title ?? "No data")

                await MainActor.run {
                    self.giveaways = data
                    print("=======> self.giveaways = ", self.giveaways.count)
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
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
     
     func isFave(_ id: Int) -> Bool {
         return favoriteIDs.contains("\(id)")
     }
     
     // Toggle favorite status and update cached favorites
     func toggleFavorite(_ id: Int) async {
         await favoriteManager.toggleFavorite("\(id)")
         favoriteIDs = await favoriteManager.getFavoriteIDs()
     }

//    private func extractPlatforms() {
//        let allPlatforms = giveaways.compactMap { $0.platforms?.components(separatedBy: ", ") }
//        let extractedPlatforms = Array(Set(allPlatforms.flatMap { $0 })).sorted().map { $0.lowercased() }
//        uniquePlatforms.append(contentsOf: extractedPlatforms)
//        print("platforms", uniquePlatforms)
//    }
    
}
