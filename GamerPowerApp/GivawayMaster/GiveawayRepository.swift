//
//  GiveawayRepositoryProtocol.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 15/02/2025.
//


protocol GiveawayRepositoryProtocol {
    func fetchGiveaways(platform: Platform?) async throws -> [GiveawayModel]
}

class GiveawayRepository: GiveawayRepositoryProtocol {
    private let givawayService: GiveawayServiceProtocol

    init(givawayService: GiveawayServiceProtocol = GiveawayRemoteService()) {
        self.givawayService = givawayService
    }

    func fetchGiveaways(platform: Platform? = nil) async throws -> [GiveawayModel] {
        let target: GiveawayAPI = (platform == nil || platform == .all)
            ? .allGiveaways
            : .giveawaysByPlatform(platform: platform?.rawValue ?? "all")

        return try await givawayService.fetch(target: target)
    }
}
