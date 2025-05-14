//
//  MovieListView.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    @StateObject private var searchVM = SearchViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Always show the search bar at the top
                SearchBarView(text: $searchVM.searchText)
                    .padding(.horizontal)

                if !searchVM.searchText.isEmpty {
                    // Show search results
                    if searchVM.isLoading {
                        ProgressView("Searching...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let error = searchVM.errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        List(searchVM.suggestions) { movie in
                            NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                                MovieRow(movie: movie)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                } else {
                    // Show Now Playing List
                    if viewModel.isLoading && viewModel.movies.isEmpty {
                        ProgressView("Loading...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let error = viewModel.errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        movieList
                    }
                }
            }
            .navigationTitle("Now Playing")
            .task {
                await viewModel.fetchNowPlayingMovies()
            }
        }
    }

    private var movieList: some View {
        List {
            ForEach(viewModel.movies) { movie in
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
        let isLast = movie.id == viewModel.movies.last?.id
        let shouldFetch = !viewModel.isLoading && viewModel.canLoadMore
        if isLast && shouldFetch {
            Task {
                await viewModel.fetchNowPlayingMovies()
            }
        }
    }

    struct MovieRow: View {
        let movie: Movie

        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(movie.posterPath ?? "")")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 120)
                .cornerRadius(8)
                .clipped()

                VStack(alignment: .leading, spacing: 6) {
                    Text(movie.title)
                        .font(.headline)
                        .lineLimit(1)

                    Text("Release: \(movie.releaseDate)")
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
        }
    }
}
