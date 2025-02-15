//
//  GiveawayRepositoryProtocol.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 15/02/2025.
//


protocol GiveawayRepositoryProtocol {
    func fetchGiveaways(platform: String?) async throws -> [GiveawayModel]
}

class GiveawayRepository: GiveawayRepositoryProtocol {
    private let givawayService: GiveawayServiceProtocol

    init(givawayService: GiveawayServiceProtocol = GiveawayRemoteService()) {
        self.givawayService = givawayService
    }

    func fetchGiveaways(platform: String? = nil) async throws -> [GiveawayModel] {
        let target: GiveawayAPI = platform != nil ? .giveawaysByPlatform(platform: platform!) : .allGiveaways
        return try await givawayService.fetch(target)
    }
}