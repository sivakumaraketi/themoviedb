//
//  themoviedbTests.swift
//  themoviedbTests
//
//  Created by Siva kumar Aketi on 12/05/25.
//
import XCTest
@testable import TheMovieDB


// MARK: - Protocol-based Mock NetworkManager

protocol NetworkManaging {
    func request<T: Decodable>(url: URL) async throws -> T
}

extension NetworkManager: NetworkManaging {}

final class TestableTMDBService: TMDBServiceProtocol {
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }
    
    func fetchNowPlayingMovies(page: Int) async throws -> MovieList {
        let urlStr = "\(AppConstants.API.baseURL)movie/now_playing?api_key=\(AppConstants.API.apiKey)&page=\(page)"
        guard let url = URL(string: urlStr) else { throw NetworkError.invalidURL }
        return try await networkManager.request(url: url)
    }
    
    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        let urlStr = "\(AppConstants.API.baseURL)movie/\(id)?api_key=\(AppConstants.API.apiKey)"
        guard let url = URL(string: urlStr) else { throw NetworkError.invalidURL }
        return try await networkManager.request(url: url)
    }
    
    func searchMovies(query: String) async throws -> MovieList {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NetworkError.invalidQuery
        }
        let urlStr = "\(AppConstants.API.baseURL)search/movie?api_key=\(AppConstants.API.apiKey)&query=\(encodedQuery)"
        guard let url = URL(string: urlStr) else { throw NetworkError.invalidURL }
        return try await networkManager.request(url: url)
    }
}


// MARK: - Unit Tests

final class TMDBServiceTests: XCTestCase {
    
    var service: TMDBServiceProtocol!
    
    override func setUp() {
        super.setUp()
        // Use MockNetworkManager, which is now a subclass of NetworkManager
        let mockNetworkManager = MockNetworkManager()
        service = TestableTMDBService(networkManager: mockNetworkManager)
    }
    
    func testFetchNowPlayingMoviesSuccess() async throws {
        let movies = try await service.fetchNowPlayingMovies(page: 1)
        XCTAssertEqual(movies.results.count, 2)
        XCTAssertEqual(movies.results.first?.title, "Test Movie 1")
    }
    
    func testFetchMovieDetailSuccess() async throws {
        let movie = try await service.fetchMovieDetail(id: 1)
        XCTAssertEqual(movie.title, "Test Movie 1")
        XCTAssertEqual(movie.voteAverage, 8.5)
    }
    
    func testSearchMoviesSuccess() async throws {
        let movies = try await service.searchMovies(query: "Test")
        XCTAssertEqual(movies.results.count, 2)
        XCTAssertEqual(movies.results.last?.title, "Test Movie 2")
    }
    
    func testSearchMoviesInvalidQuery() async throws {
        do {
            _ = try await service.searchMovies(query: "RRR")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

extension MovieList {
    init(results: [Movie]) {
        self.init(
            dates: nil,
            page: 1,
            results: results,
            totalPages: nil,
            totalResults: nil
        )
    }
}
