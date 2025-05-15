//
//  MockTMDBService.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 15/05/25.
//

import Foundation
@testable import TheMovieDB

final class MockTMDBService: TMDBServiceProtocol {
    var fetchNowPlayingMoviesResult: Result<MovieList, Error>!
    
    func fetchNowPlayingMovies(page: Int) async throws -> MovieList {
        switch fetchNowPlayingMoviesResult {
        case .success(let movieList):
            return movieList
        case .failure(let error):
            throw error
        case .none:
            fatalError("fetchNowPlayingMoviesResult not set")
        }
    }
    
    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        fatalError("Not needed for these tests")
    }
    
    func searchMovies(query: String) async throws -> MovieList {
        fatalError("Not needed for these tests")
    }
}
