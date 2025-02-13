//
//  GiveawayViewModel.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 12/02/2025.
//


import Foundation

@MainActor
class MasterViewModel: ObservableObject {
    @Published var giveaways: [GiveAwayModel] = []
    @Published var errorMessage: String?
    @Published var epicGamesGiveaways: [GiveAwayModel] = []
    @Published var searchText: String = ""
    
    var uniquePlatforms: [String] = []
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func fetchGiveaways(platform: String? = nil) {
        let apiService = self.apiService
        
        Task {
            do {
                let target: GiveawayAPI = platform != nil ? .giveawaysByPlatform(platform: platform!) : .allGiveaways
                
                let data: [GiveAwayModel] = try await apiService.request(target)
                print("=======> self.data = ",data.first?.title )

                
                await MainActor.run {
                    self.giveaways = data
                    print("=======> self.giveaways = ",self.giveaways.count )
                    if uniquePlatforms.isEmpty {
                        extractPlatforms()
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    var filteredGiveaways: [GiveAwayModel] {
        if searchText.isEmpty {
            return giveaways  // Return all giveaways if search is empty
        } else {
            return giveaways.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    private func extractPlatforms() {
        let allPlatforms = giveaways.compactMap { $0.platforms?.components(separatedBy: ", ") }

        uniquePlatforms = Array(Set(allPlatforms.flatMap { $0 })).sorted().map { $0.lowercased() }

        print("platforms", uniquePlatforms)
    }
    
}



struct GiveawayResponse: Decodable {
    let giveaways: [GiveAwayModel] // Wraps the array
}
