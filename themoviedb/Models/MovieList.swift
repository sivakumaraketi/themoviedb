//
//  MovieResponse.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation

/// Represents the API response for a paginated list of now playing movies
struct MovieList: Decodable {
    let dates: Dates?
    let page: Int
    let results: [Movie]
    let totalPages: Int?
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults
    }
}

struct Dates: Decodable {
    let maximum: String
    let minimum: String
}

