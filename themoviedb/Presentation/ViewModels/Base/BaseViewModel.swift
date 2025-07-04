//
//  BaseViewModel.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation
import Combine

// MARK: - ViewState
enum ViewState {
    case idle
    case loading
    case loaded
    case error(String)
}

// MARK: - Base ViewModel Protocol
@MainActor
protocol BaseViewModelProtocol: ObservableObject {
    var state: ViewState { get set }
    var errorMessage: String? { get set }
    
    func handleError(_ error: Error)
    func clearError()
}

// MARK: - Base ViewModel
@MainActor
class BaseViewModel: BaseViewModelProtocol {
    @Published var state: ViewState = .idle
    @Published var errorMessage: String?
    
    func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        state = .error(error.localizedDescription)
    }
    
    func clearError() {
        errorMessage = nil
        if case .error = state {
            state = .idle
        }
    }
    
    func setLoading() {
        state = .loading
        errorMessage = nil
    }
    
    func setLoaded() {
        state = .loaded
        errorMessage = nil
    }
}
