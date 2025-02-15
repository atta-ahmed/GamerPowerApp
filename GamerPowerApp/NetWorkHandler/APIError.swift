//
//  APIError.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 15/02/2025.
//


// MARK: - API Error Handling
enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError(Error)
    case networkError(Error)
    case serverError(statusCode: Int)
    case unknown
}
