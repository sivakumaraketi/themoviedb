//
//  MovieListViewModelTests.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 15/05/25.
//

import XCTest
@testable import TheMovieDB

@MainActor
final class MovieListViewModelTests: XCTestCase {

    var viewModel: MovieListViewModel!
    var mockService: MockTMDBService!

    override func setUp() {
        super.setUp()
        mockService = MockTMDBService()
        viewModel = MovieListViewModel(service: mockService)
    }

    func testFetchNowPlayingMoviesSuccess() async {
        mockService.fetchNowPlayingMoviesResult = .success(MockMovieList.sample)

        await viewModel.fetchNowPlayingMovies()

        XCTAssertEqual(viewModel.movies.count, 2)
        XCTAssertEqual(viewModel.movies.first?.title, "Test Movie 1")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testFetchNowPlayingMoviesFailure() async {
        mockService.fetchNowPlayingMoviesResult = .failure(NetworkError.invalidURL)

        await viewModel.fetchNowPlayingMovies()

        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, NetworkError.invalidURL.localizedDescription)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testCanLoadMorePages() {
        // currentPage = 1, totalPages = 1 by default; canLoadMore is true when currentPage <= totalPages
        XCTAssertTrue(viewModel.canLoadMore)
    }
}
