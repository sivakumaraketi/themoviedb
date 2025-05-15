//
//  MovieTests.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 15/05/25.
//

import XCTest
@testable import TheMovieDB

final class MovieTests: XCTestCase {

    func testMovieDecodingFromFile() throws {
        let jsonData = try loadJSONData(filename: "MovieMock")

        let decoder = JSONDecoder()
        let movie = try decoder.decode(Movie.self, from: jsonData)

        XCTAssertEqual(movie.id, 123)
        XCTAssertEqual(movie.title, "Sample Movie")
        XCTAssertEqual(movie.originalTitle, "Sample Movie Original")
        XCTAssertEqual(movie.posterPath, "/sampleposter.jpg")
        XCTAssertEqual(movie.voteAverage, 7.8)
        XCTAssertFalse(movie.adult)
    }


}
extension XCTestCase {
    func loadJSONData(filename: String) throws -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            XCTFail("Missing file: \(filename).json")
            throw NSError(domain: "Missing file", code: 0)
        }
        return try Data(contentsOf: url)
    }

}
