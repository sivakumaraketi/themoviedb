//
//  MovieListView.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import SwiftUI
import Kingfisher

/// View that shows a list of currently playing movies and allows searching for movies.
struct MovieListView: View {
    @StateObject private var viewModel: MovieListViewModel
    @StateObject private var searchVM: SearchViewModel
    
    private let coordinator: AppCoordinator
    private let paginationThreshold = AppConfiguration.UI.paginationThreshold

    init(coordinator: AppCoordinator, dependencyContainer: DependencyContainerProtocol) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: MovieListViewModel(
            fetchNowPlayingMoviesUseCase: dependencyContainer.fetchNowPlayingMoviesUseCase
        ))
        self._searchVM = StateObject(wrappedValue: SearchViewModel(
            searchMoviesUseCase: dependencyContainer.searchMoviesUseCase
        ))
    }

    var body: some View {
        // Master List View
        VStack(spacing: 0) {
            SearchBarView(text: $searchVM.searchText)
                .padding(.horizontal)
            
            if !searchVM.searchText.isEmpty {
                searchResultsView
            } else {
                movieListView
            }
        }
        .navigationTitle(LocalizedStrings.MovieList.nowPlaying)
        .task {
            await viewModel.fetchNowPlayingMovies()
        }
    }
    
    @ViewBuilder
    private var searchResultsView: some View {
        if searchVM.isLoading {
            ProgressView(LocalizedStrings.MovieList.searching)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let error = searchVM.errorMessage {
            ErrorView(message: error) {
                Task { await searchVM.retry() }
            }
        } else if searchVM.suggestions.isEmpty {
            EmptyStateView(message: LocalizedStrings.MovieList.noMovies)
        } else {
            List(searchVM.suggestions) { movie in
                Button {
                   coordinator.navigateToMovieDetail(id: movie.id)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        coordinator.navigationState.navigationStack
                        }
                } label: {
                    MovieRow(movie: movie)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .listStyle(PlainListStyle())
        }
    }
    
    @ViewBuilder
    private var movieListView: some View {
        if viewModel.isLoading && viewModel.movies.isEmpty {
            ProgressView(LocalizedStrings.MovieList.loading)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let error = viewModel.errorMessage {
            ErrorView(message: error) {
                Task { await viewModel.retry() }
            }
        } else if viewModel.movies.isEmpty {
            EmptyStateView(message: LocalizedStrings.MovieList.noMovies)
        } else {
            movieList
        }
    }

    private var movieList: some View {
        List {
            ForEach(viewModel.uniqueMovies) { movie in
                Button {
                    coordinator.navigateToMovieDetail(id: movie.id)
                } label: {
                    MovieRow(movie: movie)
                        .onAppear {
                            triggerPaginationIfNeeded(for: movie)
                        }
                }
                .buttonStyle(PlainButtonStyle())
            }

            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .listStyle(PlainListStyle())
    }

    private func triggerPaginationIfNeeded(for movie: MovieEntity) {
        guard viewModel.uniqueMovies.count > paginationThreshold else { return }
        
        let isNearEnd = movie.id == viewModel.uniqueMovies[viewModel.uniqueMovies.count - paginationThreshold].id
        let shouldFetch = !viewModel.isLoading && viewModel.canLoadMore
        if isNearEnd && shouldFetch {
            Task {
                await viewModel.fetchNextPageIfNeeded()
            }
        }
    }
}

// MARK: - Supporting Views
struct MovieRow: View {
    let movie: MovieEntity
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            posterImage
            movieInfo
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
    }
    
    @ViewBuilder
    private var posterImage: some View {
        if let posterURL = movie.posterImageURL,
           let url = URL(string: posterURL) {
            KFImage(url)
                .diskCacheExpiration(.days(7))
                .memoryCacheExpiration(.days(1))
                .downsampling(size: AppConfiguration.UI.imageSize)
                .resizable()
                .placeholder {
                    ProgressView()
                        .frame(width: 80, height: 120)
                }
                .cancelOnDisappear(true)
                .fade(duration: 0.25)
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 120)
                .cornerRadius(8)
                .clipped()
                .accessibilityLabel("\(LocalizedStrings.MovieDetail.moviePoster): \(movie.title)")
        } else {
            Image(systemName: "film")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 120)
                .foregroundColor(.gray)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .accessibilityHidden(true)
        }
    }
    
    @ViewBuilder
    private var movieInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(movie.title)
                .font(.headline)
                .lineLimit(1)
                .accessibilityAddTraits(.isHeader)
            
            Text("\(LocalizedStrings.MovieList.release) \(movie.releaseDate ?? LocalizedStrings.MovieList.nope)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(1)
            
            Text(movie.overview)
                .font(.footnote)
                .lineLimit(3)
                .foregroundColor(.secondary)
        }
    }
}

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("\(LocalizedStrings.Error.errorTitle) \(message)")
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(LocalizedStrings.Network.retryButton, action: onRetry)
                .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
