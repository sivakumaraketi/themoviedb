//
//  MockNetworkManager.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 15/05/25.
//

import Foundation
@testable import TheMovieDB

final class MockNetworkManager: NetworkManaging {
    func request<T: Decodable>(url: URL) async throws -> T {
        if T.self == MovieList.self {
            return MockMovieList.sample as! T
        } else if T.self == MovieDetail.self {
            return MockMovieDetail.sample as! T
        } else {
            throw NetworkError.decodingError(NSError(domain: "", code: -1, userInfo: nil))
        }
    }
}
