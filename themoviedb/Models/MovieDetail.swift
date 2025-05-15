//
//  MovieDetail.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 14/05/25.
//

/// MovieDetail model representing movie details fetched from TMDB API.
struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String?
    let voteAverage: Double?
    let posterPath: String?
    let tagline: String?
    let runtime: Int?
    let genres: [Genre]?
    let status: String?
    let budget: Int?
    let revenue: Int?
    let homepage: String?
    let imdbID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case homepage
        case budget
        case revenue
        case status
        case imdbID = "imdb_id"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case tagline
        case genres
        case runtime
    }
    /// Genre of the movie.
    struct Genre: Codable {
        let id: Int
        let name: String
    }
}


