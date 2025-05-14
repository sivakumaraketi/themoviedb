//
//  MovieDetailViewModel.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var movieId: Int

    init(movieId: Int) {
        self.movieId = movieId
    }

    func fetchMovieDetail() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await TMDBService.shared.fetchMovieDetail(id: movieId)
            movieDetail = result
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
