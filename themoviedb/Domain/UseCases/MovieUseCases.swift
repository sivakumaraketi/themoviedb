//
//  MovieUseCases.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation

// MARK: - Movie Repository Protocol
protocol MovieRepositoryProtocol {
    func fetchNowPlayingMovies(page: Int) async throws -> MovieListEntity
    func fetchMovieDetail(id: Int) async throws -> MovieDetailEntity
    func searchMovies(query: String) async throws -> MovieListEntity
}

// MARK: - Use Cases
protocol FetchNowPlayingMoviesUseCaseProtocol {
    func execute(page: Int) async throws -> MovieListEntity
}

protocol FetchMovieDetailUseCaseProtocol {
    func execute(id: Int) async throws -> MovieDetailEntity
}

protocol SearchMoviesUseCaseProtocol {
    func execute(query: String) async throws -> MovieListEntity
}

// MARK: - Use Case Implementations
struct FetchNowPlayingMoviesUseCase: FetchNowPlayingMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(page: Int) async throws -> MovieListEntity {
        return try await repository.fetchNowPlayingMovies(page: page)
    }
}

struct FetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
   
    func execute(id: Int) async throws -> MovieDetailEntity {
        return try await repository.fetchMovieDetail(id: id)
    }
}

struct SearchMoviesUseCase: SearchMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(query: String) async throws -> MovieListEntity {
        return try await repository.searchMovies(query: query)
    }
}
