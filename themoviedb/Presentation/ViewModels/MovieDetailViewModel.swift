//
//  MovieDetailViewModel.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation
import Combine

/// ViewModel responsible for fetching and managing movie detail data
@MainActor
final class MovieDetailViewModel: BaseViewModel {
    // MARK: - Published state
    @Published private(set) var movieDetail: MovieDetailEntity?

    @Published private(set) var isLoading = false
    
    // MARK: - Use Cases
    private let fetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol
    private let movieId: Int
    
    init(fetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol, movieId: Int) {
            self.fetchMovieDetailUseCase = fetchMovieDetailUseCase
            self.movieId = movieId
            super.init()
            
            // Automatically fetch when initialized
            Task {
                await fetchMovieDetail(id: movieId)
            }
        }
    
    // MARK: - Public API
    
    func fetchMovieDetail(id: Int) async {
        setLoading()
        isLoading = true
        
        do {
            let detail = try await fetchMovieDetailUseCase.execute(id: id)
            movieDetail = detail
            setLoaded()
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    func retry(id: Int) async {
        clearError()
        await fetchMovieDetail(id: id)
    }
    
    // MARK: - Computed Properties
    var formattedBudget: String {
        let result: String
        if let detail = movieDetail, detail.budget > 0 {
            result = "$\(formatNumber(detail.budget))"
        } else {
            result = LocalizedStrings.MovieList.nope
        }
        return result
    }
    
    var formattedRevenue: String {
        let result: String
        if let detail = movieDetail, detail.revenue > 0 {
            result = "$\(formatNumber(detail.revenue))"
        } else {
            result = LocalizedStrings.MovieList.nope
        }
        return result
    }
    
    var formattedRuntime: String {
        let result: String
        if let detail = movieDetail, let runtime = detail.runtime, runtime > 0 {
            result = "\(runtime) \(LocalizedStrings.MovieDetail.minutes)"
        } else {
            result = LocalizedStrings.MovieList.nope
        }
        return result
    }
    
    var formattedRating: String {
        let result = movieDetail.map { String(format: "%.1f", $0.voteAverage) } ?? LocalizedStrings.MovieList.nope
        return result
    }
    
    var genresList: String {
        let result = movieDetail?.genres.map { $0.name }.joined(separator: ", ") ?? LocalizedStrings.MovieList.nope
        return result
    }
    
    var imdbURL: URL? {
        let result = movieDetail?.imdbId.flatMap { URL(string: "\(LocalizedStrings.MovieDetail.imdbUrl)\($0)") }
        return result
    }
    
    var websiteURL: URL? {
        let result = movieDetail?.homepage.flatMap { URL(string: $0) }
        return result
    }
    
    // MARK: - Private helpers
    
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let result = formatter.string(from: NSNumber(value: number)) ?? "\(number)"
        return result
    }
}
