//
//  MockMovieDetail.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 15/05/25.
//

import Foundation
@testable import TheMovieDB

struct MockMovieDetail {
    static var sample: MovieDetail {
        MovieDetail(
            id: 1,
            title: "Test Movie 1",
            overview: "Overview 1",
            releaseDate: "2024-01-01",
            voteAverage: 8.5,
            posterPath: "/test1.jpg",
            tagline: "An epic test",
            runtime: 120,
            genres: [MovieDetail.Genre(id: 1, name: "Action")],
            status: "Released",
            budget: 100_000_000,
            revenue: 500_000_000,
            homepage: "https://example.com",
            imdbID: "tt1234567"
        )
    }
}
