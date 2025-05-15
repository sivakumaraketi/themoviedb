//
//  MockMovieList.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 15/05/25.
//

import Foundation
@testable import TheMovieDB

struct MockMovieList {
    static var sample: MovieList {
        MovieList(results: [
            Movie(
                id: 1,
                title: "Test Movie 1",
                originalTitle: "Test Movie 1",
                overview: "Overview 1",
                posterPath: "/test1.jpg",
                backdropPath: "/back1.jpg",
                releaseDate: "2024-01-01",
                voteAverage: 8.5,
                voteCount: 1500,
                popularity: 98.0,
                genreIDs: [28, 12],
                adult: false
            ),
            Movie(
                id: 2,
                title: "Test Movie 2",
                originalTitle: "Test Movie 2",
                overview: "Overview 2",
                posterPath: "/test2.jpg",
                backdropPath: "/back2.jpg",
                releaseDate: "2024-01-02",
                voteAverage: 7.2,
                voteCount: 890,
                popularity: 75.3,
                genreIDs: [35, 18],
                adult: false
            )
        ])
    }
}
