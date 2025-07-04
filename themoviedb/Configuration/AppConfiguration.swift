//
//  AppConfiguration.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation
import CoreGraphics

struct AppConfiguration {
    
    struct API {
        static let baseURL = "https://api.themoviedb.org/3/"
        static let apiKey = APIKeys.tmdbApiKey
        static let imageURL = "https://image.tmdb.org/t/p"
    }
    
    struct Network {
        static let timeoutInterval: TimeInterval = 30.0
        static let cachePolicy: NSURLRequest.CachePolicy = .returnCacheDataElseLoad
    }
    
    struct Cache {
        static let diskCacheExpiration: TimeInterval = 7 * 24 * 60 * 60 // 7 days
        static let memoryCacheExpiration: TimeInterval = 24 * 60 * 60 // 1 day
    }
    
    struct UI {
        static let paginationThreshold = 3
        static let fetchCooldown: TimeInterval = 0.5
        static let imageSize = CGSize(width: 200, height: 300)
        static let thumbnailSize = CGSize(width: 80, height: 120)
    }
}
