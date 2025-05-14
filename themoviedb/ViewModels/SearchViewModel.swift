//
//  SearchViewModel.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//


import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = "" {
        didSet {
            print("searchText", searchText)
            if searchText.count >= 3 {  // Trigger search only if 3 or more characters
                searchMovies(query: searchText)
            }
        }
    }
    @Published var suggestions: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
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
                let result = try await TMDBService.shared.searchMovies(query: query)
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
