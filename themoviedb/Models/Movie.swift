//
//  Movie.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation

/// Movie model representing movie list fetched from TMDB API.
struct Movie: Decodable, Identifiable , Equatable {
    let id: Int
        let title: String
        let originalTitle: String
        let overview: String
        let posterPath: String?
        let backdropPath: String?
        let releaseDate: String?
        let voteAverage: Double
        let voteCount: Int
        let popularity: Double
        let genreIDs: [Int]
        let adult: Bool
    
    enum CodingKeys: String, CodingKey {
            case id, title, overview, popularity, adult
            case originalTitle = "original_title"
            case posterPath = "poster_path"
            case backdropPath = "backdrop_path"
            case releaseDate = "release_date"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
            case genreIDs = "genre_ids"
        }
}
