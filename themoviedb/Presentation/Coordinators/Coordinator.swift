//
//  Coordinator.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import Foundation
import SwiftUI

// MARK: - Coordinator Protocol
protocol Coordinator: ObservableObject {
    associatedtype ContentView: View
    func start() -> ContentView
}

// MARK: - App Routes
enum AppRoute: Hashable, Identifiable {
    case splash
    case movieList
    case movieDetail(id: Int)
    case search
    
    var id: String {
        switch self {
        case .splash:
            return "splash"
        case .movieList:
            return "movieList"
        case .movieDetail(let id):
            return "movieDetail_\(id)"
        case .search:
            return "search"
        }
    }
}

// MARK: - App Navigation State (iOS 15 Compatible)

class AppNavigationState: ObservableObject {
    @Published var currentRoute: AppRoute = .splash
    @Published var navigationStack: [AppRoute] = []
    
    func replace(with route: AppRoute) {
        currentRoute = route
        navigationStack.removeAll()
    }
    
    func navigate(to route: AppRoute) {
        guard !navigationStack.contains(route) else {
            return
        }
        navigationStack.append(route)
    }
    
    func navigateBack() {
        guard !navigationStack.isEmpty else {
            return
        }
        navigationStack.removeLast()
    }
    
    func navigateToRoot() {
        navigationStack.removeAll()
    }
}
