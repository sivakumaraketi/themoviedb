//
//  DependencyContainer.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation

protocol DependencyContainerProtocol {
    var networkManager: NetworkManager { get }
    var tmdbService: TMDBServiceProtocol { get }
    var movieRepository: MovieRepositoryProtocol { get }
    var fetchNowPlayingMoviesUseCase: FetchNowPlayingMoviesUseCaseProtocol { get }
    var fetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol { get }
    var searchMoviesUseCase: SearchMoviesUseCaseProtocol { get }
}

final class DependencyContainer: DependencyContainerProtocol {
    
    // MARK: - Singleton
    static let shared = DependencyContainer()
    
    private init() {}
    
    // MARK: - Dependencies
    lazy var networkManager: NetworkManager = {
        return NetworkManager.shared
    }()
    
    lazy var tmdbService: TMDBServiceProtocol = {
        return TMDBService(networkManager: networkManager)
    }()
    
    lazy var movieRepository: MovieRepositoryProtocol = {
        return MovieRepository(tmdbService: tmdbService)
    }()
    
    lazy var fetchNowPlayingMoviesUseCase: FetchNowPlayingMoviesUseCaseProtocol = {
        return FetchNowPlayingMoviesUseCase(repository: movieRepository)
    }()
    
    lazy var fetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol = {
        return FetchMovieDetailUseCase(repository: movieRepository)
    }()
    
    lazy var searchMoviesUseCase: SearchMoviesUseCaseProtocol = {
        return SearchMoviesUseCase(repository: movieRepository)
    }()
}

// MARK: - Test Container for Unit Tests
final class TestDependencyContainer: DependencyContainerProtocol {
    var networkManager: NetworkManager
    var tmdbService: TMDBServiceProtocol
    var movieRepository: MovieRepositoryProtocol
    var fetchNowPlayingMoviesUseCase: FetchNowPlayingMoviesUseCaseProtocol
    var fetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol
    var searchMoviesUseCase: SearchMoviesUseCaseProtocol
    
    init(
        networkManager: NetworkManager? = nil,
        tmdbService: TMDBServiceProtocol? = nil,
        movieRepository: MovieRepositoryProtocol? = nil
    ) {
        self.networkManager = networkManager ?? NetworkManager.shared
        self.tmdbService = tmdbService ?? TMDBService(networkManager: self.networkManager)
        self.movieRepository = movieRepository ?? MovieRepository(tmdbService: self.tmdbService)
        self.fetchNowPlayingMoviesUseCase = FetchNowPlayingMoviesUseCase(repository: self.movieRepository)
        self.fetchMovieDetailUseCase = FetchMovieDetailUseCase(repository: self.movieRepository)
        self.searchMoviesUseCase = SearchMoviesUseCase(repository: self.movieRepository)
    }
}
