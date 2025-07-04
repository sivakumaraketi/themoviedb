//
//  SplashView.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import SwiftUI

struct SplashView: View {
    private let coordinator: AppCoordinator
    @State private var isActive = false
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "film.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .scaleEffect(isActive ? 1.0 : 0.8)
                    .animation(.easeInOut(duration: 1.0), value: isActive)
                
                Text(LocalizedStrings.Splash.logoTitle)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .opacity(isActive ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 1.0).delay(0.5), value: isActive)
            }
            
            Spacer()
        }
        .onAppear {
            isActive = true
            
            // Navigate to movie list after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                coordinator.navigateToMovieList()
            }
        }
        .navigationBarHidden(true)
    }
}
