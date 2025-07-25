//
//  LocalizedStrings.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation

struct LocalizedStrings {
    
    struct Network {
        static let noInternet = "No internet. Will retry once connection is back."
        static let retryButton = "Retry"
        static let fetchingMovies = "Fetching latest movies..."
    }
    
    struct Error {
        static let invalidUrl = "Invalid URL"
        static let decodeError = "Failed to decode response:"
        static let serverError = "Server returned status code"
        static let unknownError = "Unknown error:"
        static let invalidQueryError = "Search query is invalid or could not be encoded"
        static let invalidServerResponse = "Invalid response from server"
        static let noError = "No error message"
        static let errorTitle = "Error:"
    }
    
    struct MovieList {
        static let nope = "N/A"
        static let title = "Latest Movies"
        static let releaseDate = "Release Date: "
        static let loadingMore = "Loading more movies..."
        static let nowPlaying = "Now Playing"
        static let noMovies = "No movies available."
        static let loading = "Loading..."
        static let searching = "Searching..."
        static let release = "Release:"
        static let noImage = "No Image"
        static let initialMovieText = "Select a movie to view details"
    }
    
    struct MovieDetail {
        static let movieDetailTitle = "Movie Details"
        static let imb = "View on IMDb"
        static let officialWebsite = "Official Website"
        static let status = "Status:"
        static let revenue = "Revenue:"
        static let budget = "Budget:"
        static let runTime = "Runtime:"
        static let minutes = "mins"
        static let rating = "Rating:"
        static let genre = "Genres:"
        static let imdbUrl = "https://www.imdb.com/title/"
        static let moviePoster = "Movie poster"
    }
    
    struct Search {
        static let searchTitle = "Search movies..."
        static let systemName = "magnifyingglass"
        static let systemButtonName = "xmark.circle.fill"
        static let accessibilitySearch = "Clear search"
        static let accessibilitySearchTitle = "Search movies"
        static let accessibilitySearchHint = "Type to search for movies"
    }
    
    struct Splash {
        static let logoTitle = "The Movie DB"
    }
}
