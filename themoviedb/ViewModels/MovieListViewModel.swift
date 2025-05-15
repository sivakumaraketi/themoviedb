//
//  MovieListViewModel.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation
import Combine
import Kingfisher

/// ViewModel responsible for fetching and managing the list of now-playing movies,
/// handling pagination, loading state, and error messages for the movie list view.
@MainActor
final class MovieListViewModel: ObservableObject {
    // MARK: – Published state
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Debounce Control
     private var lastFetchTime: Date = .distantPast
     private let fetchCooldown: TimeInterval = 0.5 

    // MARK: – Paging state
    private var currentPage = 1
    private var totalPages = 1
    var canLoadMore: Bool { currentPage <= totalPages }
    
    private let service: TMDBServiceProtocol
    
    init(service: TMDBServiceProtocol = TMDBService.shared) {
        self.service = service
    }
    
    // Expose deduplicated movies to the View to avoid duplicate IDs in UI
    var uniqueMovies: [Movie] {
        var seen = Set<Int>()
        return movies.filter { seen.insert($0.id).inserted }
    }

    // MARK: – Public API
    
    // Initial or fresh fetch - reset pagination
    func fetchNowPlayingMovies() async {
        resetPagination()
        lastFetchTime = .distantPast // Reset debounce timer
        await fetch()
    }
    
    // Pagination load for next pages
    func fetchNextPageIfNeeded() async {
        // Debounce check
               guard Date().timeIntervalSince(lastFetchTime) > fetchCooldown else {
                   return
               }
               
        guard !isLoading, canLoadMore else { return }
        await fetch()
    }
    
    // Retry loading after error (also resets)
    func retry() async {
        resetPagination()
        await fetch()
    }

    // MARK: – Private helpers
    
    private func resetPagination() {
        currentPage = 1
        totalPages = 1
        movies.removeAll()
        errorMessage = nil
    }
    
    private func fetch() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await service.fetchNowPlayingMovies(page: currentPage)
            
            // Append new results avoiding duplicates
            let newMovies = result.results.filter { newMovie in
                !movies.contains(where: { $0.id == newMovie.id })
            }
            movies.append(contentsOf: newMovies)
            
            currentPage += 1
            totalPages = result.totalPages ?? totalPages
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    deinit {
        KingfisherManager.shared.cache.clearMemoryCache()
    }
}
