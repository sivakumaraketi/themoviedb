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
    @StateObject private var viewModel = MovieListViewModel()
    @StateObject private var searchVM = SearchViewModel()
    
    private let paginationThreshold = 3

    var body: some View {
        NavigationView {
            // Master List View
            VStack(spacing: 0) {
                SearchBarView(text: $searchVM.searchText)
                    .padding(.horizontal)
                
                if !searchVM.searchText.isEmpty {
                    if searchVM.isLoading {
                        ProgressView(AppConstants.MovieList.searching)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let error = searchVM.errorMessage {
                        Text("\(AppConstants.Error.errorTitle) \(error)")
                            .foregroundColor(.red)
                            .padding()
                    } else if searchVM.suggestions.isEmpty {
                        Text(AppConstants.MovieList.noMovies)
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    } else {
                        List(searchVM.suggestions) { movie in
                            NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                                MovieRow(movie: movie)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                } else {
                    if viewModel.isLoading && viewModel.movies.isEmpty {
                        ProgressView(AppConstants.MovieList.loading)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let error = viewModel.errorMessage {
                        Text("\(AppConstants.Error.errorTitle) \(error)")
                            .foregroundColor(.red)
                            .padding()
                    } else if viewModel.movies.isEmpty {
                        Text(AppConstants.MovieList.noMovies)
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    } else {
                        movieList
                    }
                }
            }
            .navigationTitle(AppConstants.MovieList.nowPlaying)
            .task {
                await viewModel.fetchNowPlayingMovies()
            }
            
            // Detail Placeholder for iPad split view
            Text(AppConstants.MovieList.initialMovieText)
                .font(.title2)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var movieList: some View {
        List {
            ForEach(viewModel.uniqueMovies) { movie in
                NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                    MovieRow(movie: movie)
                        .onAppear {
                            triggerPaginationIfNeeded(for: movie)
                        }
                }
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

    private func triggerPaginationIfNeeded(for movie: Movie) {
        guard viewModel.uniqueMovies.count > paginationThreshold else { return }
        
        let isNearEnd = movie.id == viewModel.uniqueMovies[viewModel.uniqueMovies.count - paginationThreshold].id
        let shouldFetch = !viewModel.isLoading && viewModel.canLoadMore
        if isNearEnd && shouldFetch {
            Task {
                await viewModel.fetchNextPageIfNeeded()
            }
        }
    }

    private struct MovieRow: View {
        let movie: Movie
        
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                if let posterPath = movie.posterPath,
                   let url = URL(string: "\(AppConstants.API.imageURL)/w200\(posterPath)") {
                    KFImage(url)
                        .diskCacheExpiration(.days(7))
                        .memoryCacheExpiration(.days(1))
                        .downsampling(size: CGSize(width: 200, height: 300))
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
                        .accessibilityLabel("Movie poster: \(movie.title)")
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
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(movie.title)
                        .font(.headline)
                        .lineLimit(1)
                        .accessibilityAddTraits(.isHeader)
                    
                    Text("\(AppConstants.MovieList.release) \(movie.releaseDate ?? AppConstants.MovieList.nope)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    Text(movie.overview)
                        .font(.footnote)
                        .lineLimit(3)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 6)
            .accessibilityElement(children: .combine)
        }
    }
}
