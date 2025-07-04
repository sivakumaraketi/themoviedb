//
//  themoviedbApp.swift
//  themoviedb
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import SwiftUI

@main
struct themoviedbApp: App {
    private let coordinator = AppCoordinator(dependencyContainer: DependencyContainer.shared)
    
    var body: some Scene {
        WindowGroup {
            coordinator.start()
        }
    }
}
