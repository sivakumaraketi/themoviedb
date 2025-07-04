//
//  AppCoordinator.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import SwiftUI

final class AppCoordinator: Coordinator {
    @Published var navigationState = AppNavigationState()
       private let dependencyContainer: DependencyContainer
       
       init(dependencyContainer: DependencyContainer) {
           self.dependencyContainer = dependencyContainer
       }
       
       func navigateToMovieDetail(id: Int) {
          navigationState.navigate(to: .movieDetail(id: id))
       }
       
    
    func start() -> some View {
        CoordinatorRootView(
            navigationState: navigationState,
            coordinator: self,
            dependencyContainer: dependencyContainer
        )
    }
    
    func navigateToMovieList() {
        navigationState.replace(with: .movieList)
    }
    
//    func navigateToMovieDetail(id: Int) {
//        navigationState.navigate(to: .movieDetail(id: id))
//    }
    
    func navigateBack() {
        navigationState.navigateBack()
    }
    
    func navigateToRoot() {
        navigationState.navigateToRoot()
    }
}
