//
//  Constants.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation

// MARK: - Deprecated - Use AppConfiguration and LocalizedStrings instead
// This file is kept temporarily for migration purposes
struct AppConstants {
    
    // MARK: - API Configuration (moved to AppConfiguration)
    struct API {
        static let baseURL = AppConfiguration.API.baseURL
        static let apiKey = AppConfiguration.API.apiKey
        static let imageURL = AppConfiguration.API.imageURL
    }
    
    // MARK: - Network Messages (moved to LocalizedStrings)
    struct Network {
        static let noInternet = LocalizedStrings.Network.noInternet
        static let retryButton = LocalizedStrings.Network.retryButton
        static let fetchingMovies = LocalizedStrings.Network.fetchingMovies
    }
    
    // MARK: - Error Messages (moved to LocalizedStrings)
    struct Error {
        static let inValidUrl = LocalizedStrings.Error.invalidUrl
        static let decodeError = LocalizedStrings.Error.decodeError
        static let serverError = LocalizedStrings.Error.serverError
        static let unknownError = LocalizedStrings.Error.unknownError
        static let invalidQueryError = LocalizedStrings.Error.invalidQueryError
        static let inValidServerResponse = LocalizedStrings.Error.invalidServerResponse
        static let noError = LocalizedStrings.Error.noError
        static let errorTitle = LocalizedStrings.Error.errorTitle
    }
    
    // MARK: - Movie List Strings (moved to LocalizedStrings)
    struct MovieList {
        static let nope = LocalizedStrings.MovieList.nope
        static let title = LocalizedStrings.MovieList.title
        static let releaseDate = LocalizedStrings.MovieList.releaseDate
        static let loadingMore = LocalizedStrings.MovieList.loadingMore
        static let nowPlaying = LocalizedStrings.MovieList.nowPlaying
        static let noMovies = LocalizedStrings.MovieList.noMovies
        static let loading = LocalizedStrings.MovieList.loading
        static let searching = LocalizedStrings.MovieList.searching
        static let release = LocalizedStrings.MovieList.release
        static let noImage = LocalizedStrings.MovieList.noImage
        static let initialMovieText = LocalizedStrings.MovieList.initialMovieText
    }
    
    // MARK: - Movie Detail Strings (moved to LocalizedStrings)
    struct MovieDetail {
        static let movieDetailTitle = LocalizedStrings.MovieDetail.movieDetailTitle
        static let imb = LocalizedStrings.MovieDetail.imb
        static let officialWebsite = LocalizedStrings.MovieDetail.officialWebsite
        static let status = LocalizedStrings.MovieDetail.status
        static let revenue = LocalizedStrings.MovieDetail.revenue
        static let budget = LocalizedStrings.MovieDetail.budget
        static let runTime = LocalizedStrings.MovieDetail.runTime
        static let minutes = LocalizedStrings.MovieDetail.minutes
        static let rating = LocalizedStrings.MovieDetail.rating
        static let genre = LocalizedStrings.MovieDetail.genre
        static let imdbUrl = LocalizedStrings.MovieDetail.imdbUrl
        static let moviePoster = LocalizedStrings.MovieDetail.moviePoster
    }
    
    // MARK: - Search Strings (moved to LocalizedStrings)
    struct Search {
        static let searchTitle = LocalizedStrings.Search.searchTitle
        static let systemName = LocalizedStrings.Search.systemName
        static let systemButtonName = LocalizedStrings.Search.systemButtonName
        static let accessiblitySearch = LocalizedStrings.Search.accessibilitySearch
        static let accessiblitySearchTitle = LocalizedStrings.Search.accessibilitySearchTitle
        static let accessiblitySearchHint = LocalizedStrings.Search.accessibilitySearchHint
    }
    
    // MARK: - Splash Strings (moved to LocalizedStrings)
    struct splash {
        static let logoTitle = LocalizedStrings.Splash.logoTitle
    }
}
