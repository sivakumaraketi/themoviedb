//
//  NetworkManager.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation

//enum for HTTP methods
enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}
//Custom network error handling
enum NetworkError: Error {
    case invalirURL
    case noData
    case noInternet
    case decodingError
    case unknown
}
//This singleton class to handle all network requests generally across the app
final class NetworkManager {
    
    //Singleton instance
    static let shared = NetworkManager()
    
    //Private instance make sure no other instances creeated
    private init() {}
    
    //Generic function to perform API calls
    func request<T: Decodable>(
        url: URL,
        method: HTTPMethod = .GET,
        headers: [String: String]? = nil,
        body: Data? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        
        //Internet Connection Check
        if !NetworkMonitor.shared.isConnected {
            completion(.failure(NetworkError.noInternet))
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        //Add headers if any
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
            
        }
        
        //Start data task
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            //Handle errpr
            if let error = error {
                completion(.failure(error))
                return
            }
            
            //Validate response
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            //Decode the response
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
            
        }.resume()
    }
    
}
