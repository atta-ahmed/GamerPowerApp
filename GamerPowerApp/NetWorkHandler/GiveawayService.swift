//
//  GiveawayServiceProtocol.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 12/02/2025.
//


import Moya

protocol GiveawayServiceProtocol {
    // fetch from api
    func fetch(target: GiveawayAPI) async throws -> [GiveawayModel]
}


class GiveawayRemoteService: GiveawayServiceProtocol  {
    private let apiClient: APIClientProtocol
    private let provider: MoyaProvider<GiveawayAPI>
    
    init(provider: MoyaProvider<GiveawayAPI> = MoyaProvider<GiveawayAPI>(),
         apiClient: APIClientProtocol = APIClient()) {
        self.provider = provider
        self.apiClient = apiClient
    }
    
    func fetch(target: GiveawayAPI) async throws -> [GiveawayModel] {
        let request = try buildRequest(for: target)
        return try await apiClient.request(request)
    }

    private func buildRequest(for target: TargetType) throws -> URLRequest {
        let url = target.baseURL.appendingPathComponent(target.path)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)

        if case let .requestParameters(parameters, encoding) = target.task,
           encoding is URLEncoding {
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }

        guard let finalURL = urlComponents?.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = target.method.rawValue
        request.allHTTPHeaderFields = target.headers
        return request
    }
    
    
}
