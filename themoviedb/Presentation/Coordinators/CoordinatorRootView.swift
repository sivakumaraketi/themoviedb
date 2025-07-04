//
//  CoordinatorRootView.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 03/07/25.
//

import SwiftUI

struct CoordinatorRootView: View {
    @ObservedObject var navigationState: AppNavigationState
    let coordinator: AppCoordinator
    let dependencyContainer: DependencyContainer
    
    var body: some View {
        NavigationView {
            rootView
                .background(
                    NavigationLink(
                        destination: makeView(for: navigationState.navigationStack.last ?? navigationState.currentRoute),
                        isActive: Binding(
                            get: { !navigationState.navigationStack.isEmpty },
                            set: { isActive in
                                if !isActive {
                                    navigationState.navigateBack()
                                } else {
                                    // Force push if needed
                                    if navigationState.navigationStack.isEmpty {
                                        navigationState.navigate(to: navigationState.currentRoute)
                                    }
                                }
                            }
                        ),
                        label: { EmptyView() }
                    )
                    .hidden()
                )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var rootView: some View {
        makeView(for: navigationState.currentRoute)
    }
    
    @ViewBuilder
    private func makeView(for route: AppRoute) -> some View {
        switch route {
        case .splash:
            SplashView(coordinator: coordinator)
        case .movieList:
            MovieListView(coordinator: coordinator, dependencyContainer: dependencyContainer)
        case .movieDetail(let id):
            MovieDetailView(movieId: id, coordinator: coordinator, dependencyContainer: dependencyContainer)
        case .search:
            EmptyView()
        }
    }
}
