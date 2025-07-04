//
//  TMDBService.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation

/// Protocols for the TMDB service
protocol TMDBServiceProtocol {
    func fetchNowPlayingMovies(page: Int) async throws -> MovieList
    func fetchMovieDetail(id: Int) async throws -> MovieDetail
    func searchMovies(query: String) async throws -> MovieList
}

/// Final class to interact with the movie database API
final class TMDBService: TMDBServiceProtocol {
    
    private let networkManager: NetworkManager
    
    /// Allow injection for unit tests
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    
    /// Endpoint to get the list of now playing movies
    /// Page for pagination implementation
    func fetchNowPlayingMovies(page: Int) async throws -> MovieList {
        let urlStr = "\(AppConstants.API.baseURL)movie/now_playing?api_key=\(AppConstants.API.apiKey)&page=\(page)"
        
        guard let url = URL(string: urlStr) else {
            throw NetworkError.invalidURL
        }
        
        do {
            return try await networkManager.request(url: url)
        } catch {
            throw mapError(error)
        }
    }
    
    
    /// Endpoint to get the movie details by movie ID
    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        let urlStr = "\(AppConstants.API.baseURL)movie/\(id)?api_key=\(AppConstants.API.apiKey)"
        
        guard let url = URL(string: urlStr) else {
            throw NetworkError.invalidURL
        }
        do {
            return try await networkManager.request(url: url)
        } catch {
            throw mapError(error)
        }
        
    }
    
    /// Endpoint to get the movie details by movie query for search
    func searchMovies(query: String) async throws -> MovieList {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NetworkError.invalidQuery
        }
        
        let url = "\(AppConstants.API.baseURL)search/movie?api_key=\(AppConstants.API.apiKey)&query=\(encodedQuery)"
        
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        do {
            return try await networkManager.request(url: url)
        } catch {
            throw mapError(error)
        }
        
    }
    
    /// mapError used for error handling
    private func mapError(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        }
        return .unknown(error)
    }
}





