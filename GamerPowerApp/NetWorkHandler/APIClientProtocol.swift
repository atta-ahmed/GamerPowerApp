//
//  APIClientProtocol.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 12/02/2025.
//


import Alamofire

protocol APIClientProtocol {
    func request<T: Decodable & Sendable>(_ request: URLRequest) async throws -> T
}


class APIClient: APIClientProtocol {
    func request<T: Decodable & Sendable>(_ request: URLRequest) async throws -> T {
        do {
            let response = try await AF.request(request)
                .validate(statusCode: 200..<300) // Ensure valid HTTP response
                .serializingDecodable(T.self)
                .value
            
            logSuccess(request: request, data: response)
            return response
            
        } catch let afError as AFError {
            logError(request: request, error: afError)
            throw handleAlamofireError(afError)
            
        } catch {
            logError(request: request, error: error)
            throw APIError.networkError(error)
        }
    }

    // MARK: - Error Handling
    private func handleAlamofireError(_ error: AFError) -> APIError {
        switch error {
        case .sessionTaskFailed(let urlError):
            return .networkError(urlError)
        case .responseSerializationFailed(reason: .decodingFailed(let decodingError)):
            return .decodingError(decodingError)
        case .responseValidationFailed(reason: .unacceptableStatusCode(let code)):
            return .serverError(statusCode: code)
        default:
            return .networkError(error)
        }
    }

    // MARK: - Logging (For Debugging)
    private func logSuccess<T: Decodable>(request: URLRequest, data: T) {
        print("✅ [SUCCESS] \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
    }

    private func logError(request: URLRequest, error: Error) {
        print("❌ [ERROR] \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "") - \(error.localizedDescription)")
    }
}
