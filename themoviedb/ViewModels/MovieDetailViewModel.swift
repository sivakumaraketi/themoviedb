//
//  MovieDetailViewModel.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation

/// ViewModel responsible for fetching and managing the details for now playing movies
@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var movieId: Int
    private let service: TMDBServiceProtocol

    init(movieId: Int, service: TMDBServiceProtocol = TMDBService.shared) {
            self.movieId = movieId
            self.service = service
        }

    func fetchMovieDetail() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await service.fetchMovieDetail(id: movieId)
            movieDetail = result
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
