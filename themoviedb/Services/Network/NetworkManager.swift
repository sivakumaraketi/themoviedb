//
//  NetworkManager.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation

/// Enum for common networking errors.
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case decodingError(Error)
    case serverError(statusCode: Int, message: String)
    case unknown(Error)
    case invalidQuery
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return AppConstants.Error.inValidUrl
        case .decodingError(let error):
            return "\(AppConstants.Error.decodeError) \(error.localizedDescription)"
        case .serverError(let statusCode, let message):
            return "\(AppConstants.Error.serverError) \(statusCode): \(message)"
        case .unknown(let error):
            return "\(AppConstants.Error.unknownError) \(error.localizedDescription)"
        case .invalidQuery:
            return AppConstants.Error.invalidQueryError
        }
    }
}

/// Sends a request and decodes the response to a generic Decodable type.
final class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession
    
    /// Allows custom session injection (useful for unit testing).
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Sends a request and decodes the response to a generic Decodable type.
    func request<T: Decodable>(url: URL) async throws -> T {
        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw NetworkError.unknown(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError(statusCode: -1, message: AppConstants.Error.inValidServerResponse)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            let message = String(data: data, encoding: .utf8) ?? AppConstants.Error.noError
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: message)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
