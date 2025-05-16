//
//  SplashViewModel.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 16/05/25.
//

import Foundation

class SplashViewModel: ObservableObject {
    @Published var isActive = false

    init() {
        startSplash()
    }

    func startSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isActive = true
        }
    }
}

