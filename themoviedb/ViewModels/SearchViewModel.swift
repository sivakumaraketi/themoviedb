//
//  SearchViewModel.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//


import Foundation
import Combine

/// ViewModel that manages movie search functionality
/// Requires at least 3 characters to initiate search
final class SearchViewModel: ObservableObject {
    @Published var searchText: String = "" {
        didSet {
            if searchText.count >= 3 {  // Trigger search only if 3 or more characters
                searchMovies(query: searchText)
            }
        }
    }
    @Published var suggestions: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let service: TMDBServiceProtocol

        init(service: TMDBServiceProtocol = TMDBService.shared) {
            self.service = service
        }
    
    func searchMovies(query: String) {
        guard !query.isEmpty else {
            DispatchQueue.main.async {
                self.suggestions = []
            }
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        Task {
            do {
                let result = try await service.searchMovies(query: query)
                await MainActor.run {
                    self.suggestions = result.results
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
