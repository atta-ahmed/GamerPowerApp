//
//  GiveawayServiceProtocol.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 12/02/2025.
//


import Moya

protocol GiveawayServiceProtocol {
    // fetch from api
    func fetch<T: Decodable>(_ target: GiveawayAPI) async throws -> T

}


class GiveawayRemoteService: GiveawayServiceProtocol  {
    private let apiClient: APIClientProtocol
    private let provider: MoyaProvider<GiveawayAPI>
    
    init(provider: MoyaProvider<GiveawayAPI> = MoyaProvider<GiveawayAPI>(),
         apiClient: APIClientProtocol = APIClient()) {
        self.provider = provider
        self.apiClient = apiClient
    }
    
    func fetch<T: Decodable>(_ target: GiveawayAPI) async throws -> T {
        return try await apiClient.request(target)
    }
    
}

