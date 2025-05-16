//
//  SplashView.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 16/05/25.
//
import SwiftUI


/// Basic splash screen
struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()

    var body: some View {
        Group {
            if viewModel.isActive {
                MovieListView()
            } else {
                VStack {
                    Image(systemName: "film")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text(AppConstants.splash.logoTitle)
                        .font(.largeTitle)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
