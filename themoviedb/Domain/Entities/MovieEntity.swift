//
//  MovieEntity.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation

// MARK: - Domain Entity
struct MovieEntity: Identifiable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String?
    let posterImageURL: String?
    let backdropImageURL: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let originalLanguage: String
    let originalTitle: String
    let adult: Bool
    let video: Bool
    let genreIds: [Int]
    
    static func == (lhs: MovieEntity, rhs: MovieEntity) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Domain Entity for Movie List
struct MovieListEntity {
    let page: Int
    let results: [MovieEntity]
    let totalPages: Int
    let totalResults: Int
}

// MARK: - Domain Entity for Movie Detail
struct MovieDetailEntity: Identifiable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String?
    let posterImageURL: String?
    let backdropImageURL: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let originalLanguage: String
    let originalTitle: String
    let adult: Bool
    let video: Bool
    let runtime: Int?
    let budget: Int
    let revenue: Int
    let status: String
    let tagline: String?
    let imdbId: String?
    let homepage: String?
    let genres: [GenreEntity]
    let productionCompanies: [ProductionCompanyEntity]
    let productionCountries: [ProductionCountryEntity]
    let spokenLanguages: [SpokenLanguageEntity]
}

struct GenreEntity: Identifiable {
    let id: Int
    let name: String
}

struct ProductionCompanyEntity: Identifiable {
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String
}

struct ProductionCountryEntity: Identifiable {
    let id = UUID()
    let iso31661: String
    let name: String
}

struct SpokenLanguageEntity: Identifiable {
    let id = UUID()
    let englishName: String
    let iso6391: String
    let name: String
}
