//
//  GiveawayServiceProtocol.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 12/02/2025.
//


import Moya

protocol GiveawayServiceProtocol {
    func fetch(target: GiveawayAPI) async throws -> [GiveawayModel]
}

class GiveawayRemoteService: GiveawayServiceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetch(target: GiveawayAPI) async throws -> [GiveawayModel] {
        let request = try buildRequest(for: target)
        
        do {
            let response = try await apiClient.request(request) as [GiveawayModel]
            logSuccess(request: request)
            return response
        } catch {
            logError(request: request, error: error)
            throw error
        }
    }

    private func buildRequest(for target: TargetType) throws -> URLRequest {
        guard var urlComponents = URLComponents(
            url: target.baseURL.appendingPathComponent(target.path),
            resolvingAgainstBaseURL: false
        ) else {
            throw APIError.invalidURL
        }
        
        if case let .requestParameters(parameters, encoding) = target.task,
           encoding is URLEncoding {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let finalURL = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = target.method.rawValue
        request.allHTTPHeaderFields = target.headers
        return request
    }
    
    // MARK: - Logging for Debugging
    private func logSuccess(request: URLRequest) {
        print("✅ [SUCCESS Service] \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
    }

    private func logError(request: URLRequest, error: Error) {
        print("❌ [ERROR Service] \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "") - \(error.localizedDescription)")
    }
}
