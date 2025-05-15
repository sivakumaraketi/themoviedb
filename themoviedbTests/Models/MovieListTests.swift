//
//  MovieListTests.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 15/05/25.
//

import XCTest
@testable import TheMovieDB

final class MovieListTests: XCTestCase {

    func testMovieListDecodingFromMock() throws {
        let data = try loadJSONData(filename: "MovieListMock")

        let decoder = JSONDecoder()
        let movieList = try decoder.decode(MovieList.self, from: data)

        XCTAssertEqual(movieList.page, 1)
        XCTAssertEqual(movieList.results.count, 2)
        XCTAssertEqual(movieList.totalPages, 10)
        XCTAssertEqual(movieList.dates?.maximum, "2025-05-30")
    }
}
