//
//  SearchViewModel.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation
import Combine

/// ViewModel responsible for handling movie search functionality
@MainActor
final class SearchViewModel: BaseViewModel {
    // MARK: - Published state
    @Published var searchText = ""
    @Published private(set) var suggestions: [MovieEntity] = []
    @Published private(set) var isLoading = false
    
    // MARK: - Private properties
    private var searchCancellable: AnyCancellable?
    private let searchMoviesUseCase: SearchMoviesUseCaseProtocol
    private let debounceDelay: TimeInterval = 0.5
    
    init(searchMoviesUseCase: SearchMoviesUseCaseProtocol) {
        self.searchMoviesUseCase = searchMoviesUseCase
        super.init()
        setupSearchDebouncing()
    }
    
    // MARK: - Private methods
    
    private func setupSearchDebouncing() {
        searchCancellable = $searchText
            .debounce(for: .seconds(debounceDelay), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                Task { @MainActor in
                    await self?.performSearch(query: searchText)
                }
            }
    }
    
    private func performSearch(query: String) async {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            suggestions.removeAll()
            clearError()
            return
        }
        
        setLoading()
        isLoading = true
        
        do {
            let result = try await searchMoviesUseCase.execute(query: query)
            suggestions = result.results
            setLoaded()
        } catch {
            handleError(error)
            suggestions.removeAll()
        }
        
        isLoading = false
    }
    
    // MARK: - Public methods
    
    func clearSearch() {
        searchText = ""
        suggestions.removeAll()
        clearError()
    }
    
    func retry() async {
        guard !searchText.isEmpty else { return }
        await performSearch(query: searchText)
    }
    
    deinit {
        searchCancellable?.cancel()
    }
}
