//
//  MovieRepository.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation

final class MovieRepository: MovieRepositoryProtocol {
    private let tmdbService: TMDBServiceProtocol
    
    init(tmdbService: TMDBServiceProtocol) {
        self.tmdbService = tmdbService
    }
    
    func fetchNowPlayingMovies(page: Int) async throws -> MovieListEntity {
        let apiModel = try await tmdbService.fetchNowPlayingMovies(page: page)
        return MovieMapper.mapToEntity(from: apiModel)
    }
    
    func fetchMovieDetail(id: Int) async throws -> MovieDetailEntity {
        let apiModel = try await tmdbService.fetchMovieDetail(id: id)
        return MovieMapper.mapToEntity(from: apiModel)
    }
    
    func searchMovies(query: String) async throws -> MovieListEntity {
        let apiModel = try await tmdbService.searchMovies(query: query)
        return MovieMapper.mapToEntity(from: apiModel)
    }
}
