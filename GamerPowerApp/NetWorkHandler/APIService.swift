//
//  APIService.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 12/02/2025.
//


import Moya

protocol APIServiceProtocol {
    func request<T: Decodable, U: TargetType>(_ target: U) async throws -> T
}


class APIService: APIServiceProtocol  {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func request<T: Decodable, U: TargetType>(_ target: U) async throws -> T {
        return try await apiClient.request(target)
    }

}
