//
//  NetworkManagerTests.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 15/05/25.
//

import XCTest
@testable import TheMovieDB

import XCTest
@testable import TheMovieDB

final class NetworkManagerTests: XCTestCase {

    func testRequestDecodesMovieListSuccessfully() async throws {
        // Arrange: Load mock JSON data
        let data = try loadJSONData(filename: "MovieListMock")
        
        // Create a mock response with status code 200
        let url = URL(string: "https://mockapi.themoviedb.org/now_playing")!
        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!
        
        // Inject MockURLProtocol to URLSession
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: config)
        let networkManager = NetworkManager(session: mockSession)

        // Set the mock response
        MockURLProtocol.requestHandler = { _ in
            return (response, data)
        }

        // Act: Perform the request
        let movieList: MovieList = try await networkManager.request(url: url)

        // Assert: Validate decoded data
        XCTAssertEqual(movieList.page, 1)
        XCTAssertEqual(movieList.results.count, 2)
        XCTAssertEqual(movieList.results.first?.id, 123)
    }
}
