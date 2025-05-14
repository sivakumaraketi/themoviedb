//
//  Constants.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation

struct AppConstants {
    
    struct Network {
        static let noInternet = "No internet. Will retry once connection is back."
        static let retryButton = "Retry"
        static let fetchingMovies = "Fetching latest movies..."
    }
    
    struct MovieList {
        static let title = "Latest Movies"
        static let releaseDatePrefix = "Release: "
        static let loadingMore = "Loading more movies..."
    }
    
}
