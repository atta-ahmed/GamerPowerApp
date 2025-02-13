//
//  APIClientProtocol.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 12/02/2025.
//


import Moya
import Alamofire

protocol APIClientProtocol {
    func request<T: Decodable, U: TargetType>(_ target: U) async throws -> T

}

class APIClient: APIClientProtocol {
    private let provider: MoyaProvider<MultiTarget> 

    init() {
        self.provider = MoyaProvider<MultiTarget>()
    }
    
    func request<T: Decodable, U: TargetType>(_ target: U) async throws -> T {
        do {
            let endpoint = provider.endpoint(MultiTarget(target))
            let url = endpoint.url
            let method = HTTPMethod(rawValue: endpoint.method.rawValue)
            let headers = HTTPHeaders(endpoint.httpHeaderFields ?? [:])

            print("Final Request URL:", endpoint.url)

            // Validate the URL
            guard let validURL = URL(string: url) else {
                throw APIError.invalidURL
            }

            // Make the Request
            let data = try await AF.request(validURL, method: method, headers: headers)
                .validate()
                .serializingData()
                .value

            // Decode the Data
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decodingFailure(error)
            }
        } catch let afError as AFError {
            throw APIError.networkFailure(afError)
        } catch {
            throw APIError.unknown
        }
    }


}

enum APIError: Error {
    case invalidURL
    case networkFailure(Error)
    case decodingFailure(Error)
    case unknown
}
