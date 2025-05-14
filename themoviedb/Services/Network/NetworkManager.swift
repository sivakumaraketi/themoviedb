//
//  NetworkManager.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case serverError
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func request<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.serverError
        }

        do {
            print("urlstrresp1", data)
            print("urlstrresp", try? JSONDecoder().decode(T.self, from: data))
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
}
