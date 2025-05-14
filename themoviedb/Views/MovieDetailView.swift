//
//  MovieDetailView.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import SwiftUI

struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel

    init(movieId: Int) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieId: movieId))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if let movie = viewModel.movieDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Movie Poster
                        if let posterPath = movie.posterPath,
                           let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: 300)
                                    .clipped()
                            } placeholder: {
                                ProgressView()
                                    .frame(height: 300)
                                    .background(Color.gray.opacity(0.2))
                            }
                            .frame(height: 300)
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 300)
                                .overlay(Text("No Image").foregroundColor(.white))
                        }

                        // Title & Tagline
                        Text(movie.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        if let tagline = movie.tagline, !tagline.isEmpty {
                            Text("\"\(tagline)\"")
                                .italic()
                                .font(.title3)
                                .foregroundColor(.gray)
                        }

                        // Release Date
                        if let releaseDate = movie.releaseDate {
                            Text("Release Date: \(releaseDate)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        // Overview
                        Text(movie.overview)
                            .font(.body)

                        // Genres
                        if let genres = movie.genres {
                            Text("Genres: \(genres.map { $0.name }.joined(separator: ", "))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        // Rating
                        if let rating = movie.voteAverage {
                            Text("Rating: \(rating, specifier: "%.1f") / 10")
                                .font(.subheadline)
                                .foregroundColor(.yellow)
                        }

                        // Runtime
                        if let runtime = movie.runtime {
                            Text("Runtime: \(runtime) mins")
                                .font(.subheadline)
                        }

                        // Spoken Languages
//                        if let languages = movie.spokenLanguages, !languages.isEmpty {
//                            Text("Languages: \(languages.map { $0.englishName }.joined(separator: ", "))")
//                                .font(.subheadline)
//                        }

                        // Budget & Revenue
                        if let budget = movie.budget, budget > 0 {
                            Text("Budget: $\(budget.formattedWithSeparator())")
                                .font(.subheadline)
                        }

                        if let revenue = movie.revenue, revenue > 0 {
                            Text("Revenue: $\(revenue.formattedWithSeparator())")
                                .font(.subheadline)
                        }

                        // Status
                        if let status = movie.status {
                            Text("Status: \(status)")
                                .font(.subheadline)
                        }

                        // Production Companies
//                        if let companies = movie.productionCompanies, !companies.isEmpty {
//                            Text("Production Companies: \(companies.map { $0.name }.joined(separator: ", "))")
//                                .font(.subheadline)
//                        }

                        // Homepage Link
                        if let homepage = movie.homepage, let homepageURL = URL(string: homepage) {
                            Link("Official Website", destination: homepageURL)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }

                        // IMDb Link
                        if let imdbID = movie.imdbID,
                           let imdbURL = URL(string: "https://www.imdb.com/title/\(imdbID)") {
                            Link("View on IMDb", destination: imdbURL)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }

                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Movie Details", displayMode: .inline)
        .onAppear {
            Task {
                await viewModel.fetchMovieDetail()
            }
        }
    }
}

extension Int {
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
