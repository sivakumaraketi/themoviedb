//
//  MovieDetail.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 14/05/25.
//

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
    //let productionCompanies: [ProductionCompanies]?
    //let spokenLanguages: [SpokenLanguage]?
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
       // case spokenLanguages = "spoken_languages"
       // case productionCompanies = "production_companies"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case tagline
        case genres
        case runtime
    }

    struct Genre: Codable {
        let id: Int
        let name: String
    }
    
//    struct SpokenLanguage: Codable, Identifiable {
//        var id: String { iso639_1 }
//
//        let englishName: String
//        let iso639_1: String
//        let name: String
//
//        enum CodingKeys: String, CodingKey {
//            case englishName = "english_name"
//            case iso639_1
//            case name
//        }
//    }
    
//    struct ProductionCompanies: Codable, Identifiable {
//        let id: String
//        let logo_path: String
//        let name: String
//        let origin_country: String
//
//        enum CodingKeys: String, CodingKey {
//            case id
//            case logo_path
//            case name
//            case origin_country
//        }
//    }
}


