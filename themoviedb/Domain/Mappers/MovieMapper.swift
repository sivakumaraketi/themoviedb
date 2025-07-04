//
//  MovieMapper.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation

struct MovieMapper {
    
    static func mapToEntity(from apiModel: Movie) -> MovieEntity {
        let posterURL = apiModel.posterPath.map { "\(AppConfiguration.API.imageURL)/w200\($0)" }
        let backdropURL = apiModel.backdropPath.map { "\(AppConfiguration.API.imageURL)/w500\($0)" }
        
        return MovieEntity(
            id: apiModel.id,
            title: apiModel.title,
            overview: apiModel.overview,
            releaseDate: apiModel.releaseDate,
            posterImageURL: posterURL,
            backdropImageURL: backdropURL,
            voteAverage: apiModel.voteAverage,
            voteCount: apiModel.voteCount,
            popularity: apiModel.popularity,
            originalLanguage: "", // Not available in this API model
            originalTitle: apiModel.originalTitle,
            adult: apiModel.adult,
            video: false, // Not available in this API model
            genreIds: apiModel.genreIDs
        )
    }
    
    static func mapToEntity(from apiModel: MovieList) -> MovieListEntity {
        return MovieListEntity(
            page: apiModel.page,
            results: apiModel.results.map { mapToEntity(from: $0) },
            totalPages: apiModel.totalPages ?? 0,
            totalResults: apiModel.totalResults ?? 0
        )
    }
    
    static func mapToEntity(from apiModel: MovieDetail) -> MovieDetailEntity {
        let posterURL = apiModel.posterPath.map { "\(AppConfiguration.API.imageURL)/w500\($0)" }
        // No backdropPath in current API model
        
        return MovieDetailEntity(
            id: apiModel.id,
            title: apiModel.title,
            overview: apiModel.overview,
            releaseDate: apiModel.releaseDate,
            posterImageURL: posterURL,
            backdropImageURL: nil, // Not available in current API model
            voteAverage: apiModel.voteAverage ?? 0.0,
            voteCount: 0, // Not available in current API model
            popularity: 0.0, // Not available in current API model
            originalLanguage: "", // Not available in current API model
            originalTitle: apiModel.title, // Use title as fallback
            adult: false, // Not available in current API model
            video: false, // Not available in current API model
            runtime: apiModel.runtime,
            budget: apiModel.budget ?? 0,
            revenue: apiModel.revenue ?? 0,
            status: apiModel.status ?? "Unknown",
            tagline: apiModel.tagline,
            imdbId: apiModel.imdbID,
            homepage: apiModel.homepage,
            genres: (apiModel.genres ?? []).map { GenreEntity(id: $0.id, name: $0.name) },
            productionCompanies: [], // Not available in current API model
            productionCountries: [], // Not available in current API model
            spokenLanguages: [] // Not available in current API model
        )
    }
}
