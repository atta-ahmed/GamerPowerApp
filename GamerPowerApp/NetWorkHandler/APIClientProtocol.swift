//
//  APIClientProtocol.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 12/02/2025.
//


import Moya
//import Alamofire

// MARK: - Protocol Definition
protocol APIClientProtocol {
    func request<T: Decodable, U: TargetType>(_ target: U) async throws -> T
}

// MARK: - APIClient Implementation
class APIClient: APIClientProtocol {
    private let provider: MoyaProvider<MultiTarget>
    init() {
        self.provider = MoyaProvider<MultiTarget>()
    }
    func request<T: Decodable, U: TargetType>(_ target: U) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(MultiTarget(target)) { result in
                switch result {
                case .success(let response):
                    do {
                        guard (200...299).contains(response.statusCode) else {
                            continuation.resume(throwing: APIError.invalidResponse(response.statusCode))
                            return
                        }

                        let decodedData = try JSONDecoder().decode(T.self, from: response.data)
                        continuation.resume(returning: decodedData)
                    } catch {
                        continuation.resume(throwing: APIError.decodingFailure(error))
                    }

                case .failure(let moyaError):
                    continuation.resume(throwing: APIError.networkFailure(moyaError))
                }
            }
        }
    }
}
//
//import Alamofire
//
//protocol APIClientProtocol {
//    func request<T: Decodable & Sendable>(_ url: URL, parameters: [String: Any]?) async throws -> T
//}
//
//class APIClient: APIClientProtocol {
//    func request<T: Decodable & Sendable>(_ url: URL, parameters: [String: Any]?) async throws -> T {
//        return try await withCheckedThrowingContinuation { continuation in
//            AF.request(url, parameters: parameters)
//                .validate()
//                .responseDecodable(of: T.self) { response in
//                    switch response.result {
//                    case .success(let data):
//                        continuation.resume(returning: data)
//                    case .failure(let error):
//                        continuation.resume(throwing: APIError.networkFailure(error))
//                    }
//                }
//        }
//    }
//}
//
//extension APIClient: @unchecked Sendable {}
//

// ✅ Alamofire Request Interceptor (Handles Authentication)
//class APIRequestInterceptor: RequestInterceptor {
//    func adapt(_ urlRequest: URLRequest, for session: Alamofire.Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
//        var request = urlRequest
//        request.setValue("Bearer YOUR_TOKEN", forHTTPHeaderField: "Authorization")
//        completion(.success(request))
//    }
//}


// MARK: - API Error Handling
enum APIError: Error {
    case invalidURL
    case networkFailure(Error)
    case decodingFailure(Error)
    case invalidResponse(Int)
    case unknown
}
