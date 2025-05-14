//
//  MovieListViewModel.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation
import Combine

@MainActor
final class MovieListViewModel: ObservableObject {
    // MARK: – Published state
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    // MARK: – Paging state
    private var currentPage = 1
    private var totalPages = 1          // will be replaced by API value
    var canLoadMore: Bool { currentPage <= totalPages }

    // MARK: – Public API
    func fetchNextPageIfNeeded() async {
        guard !isLoading, canLoadMore else { return }
        await fetch()
    }

    func retry() async {
        await fetch()
    }

    // Exposed separately if you want to load first page explicitly
    func fetchNowPlayingMovies() async {
        await fetch()
    }

    // MARK: – Private helpers
    private func fetch() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await TMDBService.shared.fetchNowPlayingMovies(page: currentPage)
            movies.append(contentsOf: result.results)
            currentPage += 1
            totalPages  = result.totalPages ?? totalPages
        } catch {
            errorMessage = error.localizedDescription
            print("Fetch error: \(error)")
        }

        isLoading = false
    }
}

