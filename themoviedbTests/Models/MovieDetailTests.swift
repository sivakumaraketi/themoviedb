//
//  MovieDetailTests.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 15/05/25.
//

import XCTest
@testable import TheMovieDB

final class MovieDetailTests: XCTestCase {

    func testMovieDetailDecodingFromMock() throws {
        let data = try loadJSONData(filename: "MovieDetailMock")

        let decoder = JSONDecoder()
        let movieDetail = try decoder.decode(MovieDetail.self, from: data)

        XCTAssertEqual(movieDetail.id, 101)
        XCTAssertEqual(movieDetail.title, "Inception")
        XCTAssertEqual(movieDetail.runtime, 148)
        XCTAssertEqual(movieDetail.genres?.count, 2)
        XCTAssertEqual(movieDetail.genres?.first?.name, "Action")
        XCTAssertEqual(movieDetail.imdbID, "tt1375666")
        XCTAssertEqual(movieDetail.budget, 160000000)
        XCTAssertEqual(movieDetail.revenue, 825532764)
    }
}
