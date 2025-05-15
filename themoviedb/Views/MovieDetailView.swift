//
//  MovieDetailView.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import SwiftUI
import Kingfisher

/// View that shows a details of selected movie
struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel
    
    init(movieId: Int) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieId: movieId))
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView(AppConstants.MovieList.loading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                Text("\(AppConstants.Error.errorTitle) \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if let movie = viewModel.movieDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Movie Poster
                        if let posterPath = movie.posterPath,
                           let imageURL = URL(string: "\(AppConstants.API.imageURL)/w500\(posterPath)") {
                            KFImage(imageURL)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 300)
                                .clipped()
                                .accessibilityLabel(AppConstants.MovieDetail.moviePoster)
                        }  else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 300)
                                .overlay(Text(AppConstants.MovieList.noImage).foregroundColor(.white))
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
                            Text("\(AppConstants.MovieList.releaseDate) \(releaseDate)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        // Overview
                        Text(movie.overview)
                            .font(.body)
                        
                        // Genres
                        if let genres = movie.genres {
                            Text("\(AppConstants.MovieDetail.gene) \(genres.map { $0.name }.joined(separator: ", "))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        // Rating
                        if let rating = movie.voteAverage {
                            Text("\(AppConstants.MovieDetail.rating) \(rating, specifier: "%.1f") / 10")
                                .font(.subheadline)
                                .foregroundColor(.yellow)
                        }
                        
                        // Runtime
                        if let runtime = movie.runtime {
                            Text("\(AppConstants.MovieDetail.runTime) \(runtime) \(AppConstants.MovieDetail.minutes)")
                                .font(.subheadline)
                        }
                        
                        // Budget & Revenue
                        if let budget = movie.budget, budget > 0 {
                            Text("\(AppConstants.MovieDetail.budget) $\(budget.formattedWithSeparator())")
                                .font(.subheadline)
                        }
                        
                        if let revenue = movie.revenue, revenue > 0 {
                            Text("\(AppConstants.MovieDetail.revenue) $\(revenue.formattedWithSeparator())")
                                .font(.subheadline)
                        }
                        
                        // Status
                        if let status = movie.status {
                            Text("\(AppConstants.MovieDetail.status) \(status)")
                                .font(.subheadline)
                        }
                        
                        // Homepage Link
                        if let homepage = movie.homepage, let homepageURL = URL(string: homepage) {
                            Link(AppConstants.MovieDetail.officialWebsite, destination: homepageURL)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        
                        // IMDb Link
                        if let imdbID = movie.imdbID,
                           let imdbURL = URL(string: "\(AppConstants.MovieDetail.imdbUrl)\(imdbID)") {
                            Link(AppConstants.MovieDetail.imb, destination: imdbURL)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle(AppConstants.MovieDetail.movieDetailTitle, displayMode: .inline)
        .task {
            await viewModel.fetchMovieDetail()
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
