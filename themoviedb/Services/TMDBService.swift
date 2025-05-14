//
//  TMDBService.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation
import Combine

protocol TMDBServiceProtocol {
    func fetchNowPlayingMovies(page: Int) async throws -> MovieList
}

final class TMDBService: TMDBServiceProtocol {
    static let shared = TMDBService()
    private init() {}

    private let baseURL = "https://api.themoviedb.org/3/"
    private let apiKey = "4c5806a5de6fbed9b28f238484fede91"

    // Endpoint to get the list of now playing movies
    func fetchNowPlayingMovies(page: Int) async throws -> MovieList {
        let urlStr = "\(baseURL)movie/now_playing?api_key=\(apiKey)&page=\(page)"
        guard let url = URL(string: urlStr) else {
            throw NetworkError.invalidURL
        }
        return try await NetworkManager.shared.request(url: url)
    }
    
    
    // Endpoint to get the movie details by movie ID
    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
            let urlStr = "\(baseURL)movie/\(id)?api_key=\(apiKey)"
        print("urlstr", urlStr)
            guard let url = URL(string: urlStr) else {
                throw NetworkError.invalidURL
            }
            return try await NetworkManager.shared.request(url: url)
        }
    
    // Endpoint to get the movie details by movie ID
    func searchMovies(query: String) async throws -> MovieList {
            let urlStr = "\(baseURL)search/movie?api_key=\(apiKey)&query=\(query)"
        print("searchURL", urlStr);
            guard let url = URL(string: urlStr) else {
                throw NetworkError.invalidURL
            }
            return try await NetworkManager.shared.request(url: url)
        }
}
