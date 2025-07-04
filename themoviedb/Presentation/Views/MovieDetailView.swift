//
//  MovieDetailView.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//

import SwiftUI
import Kingfisher
import SwiftUI

struct MovieDetailView: View {
    let movieId: Int
    private let coordinator: AppCoordinator
    @StateObject private var viewModel: MovieDetailViewModel
    
    init(movieId: Int, coordinator: AppCoordinator, dependencyContainer: DependencyContainerProtocol) {
        self.movieId = movieId
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: MovieDetailViewModel(
            fetchMovieDetailUseCase: dependencyContainer.fetchMovieDetailUseCase, movieId: movieId
        ))
    }
    
    var body: some View {
        content
            .navigationTitle(LocalizedStrings.MovieDetail.movieDetailTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await viewModel.fetchMovieDetail(id: movieId)
                }
            }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView(LocalizedStrings.MovieList.loading)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let error = viewModel.errorMessage {
            ErrorView(message: error) {
                Task { await viewModel.retry(id: movieId) }
            }
        } else if let movieDetail = viewModel.movieDetail {
            movieDetailContent(movieDetail)
        }
    }
    
    @ViewBuilder
    private func movieDetailContent(_ movie: MovieDetailEntity) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                headerSection(movie)
                
                if !movie.overview.isEmpty {
                    overviewSection(movie.overview)
                }
                
                detailsSection(movie)
                
                if !movie.genres.isEmpty {
                    genresSection(movie.genres)
                }
                
                linksSection(movie)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func headerSection(_ movie: MovieDetailEntity) -> some View {
        HStack(alignment: .top, spacing: 16) {
            posterImage(movie)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .accessibilityAddTraits(.isHeader)
                
                if let releaseDate = movie.releaseDate {
                    Text("\(LocalizedStrings.MovieList.release) \(releaseDate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(viewModel.formattedRating)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                if let tagline = movie.tagline, !tagline.isEmpty {
                    Text(tagline)
                        .font(.caption)
                        .italic()
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func posterImage(_ movie: MovieDetailEntity) -> some View {
        if let posterURL = movie.posterImageURL,
           let url = URL(string: posterURL) {
            KFImage(url)
                .diskCacheExpiration(.days(7))
                .memoryCacheExpiration(.days(1))
                .resizable()
                .placeholder {
                    ProgressView()
                        .frame(width: 120, height: 180)
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 180)
                .cornerRadius(12)
                .clipped()
                .accessibilityLabel("\(LocalizedStrings.MovieDetail.moviePoster): \(movie.title)")
        } else {
            Image(systemName: "film")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 180)
                .foregroundColor(.gray)
                .background(Color(.systemGray5))
                .cornerRadius(12)
                .accessibilityHidden(true)
        }
    }
    
    @ViewBuilder
    private func overviewSection(_ overview: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overview")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            
            Text(overview)
                .font(.body)
        }
    }
    
    @ViewBuilder
    private func detailsSection(_ movie: MovieDetailEntity) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Details")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                DetailItem(title: LocalizedStrings.MovieDetail.status, value: movie.status)
                DetailItem(title: LocalizedStrings.MovieDetail.runTime, value: viewModel.formattedRuntime)
                DetailItem(title: LocalizedStrings.MovieDetail.budget, value: viewModel.formattedBudget)
                DetailItem(title: LocalizedStrings.MovieDetail.revenue, value: viewModel.formattedRevenue)
            }
        }
    }
    
    @ViewBuilder
    private func genresSection(_ genres: [GenreEntity]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStrings.MovieDetail.genre)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            
            Text(viewModel.genresList)
                .font(.body)
        }
    }
    
    @ViewBuilder
    private func linksSection(_ movie: MovieDetailEntity) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Links")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            
            VStack(spacing: 8) {
                if let imdbURL = viewModel.imdbURL {
                    Link(LocalizedStrings.MovieDetail.imb, destination: imdbURL)
                        .foregroundColor(.blue)
                }
                
                if let websiteURL = viewModel.websiteURL {
                    Link(LocalizedStrings.MovieDetail.officialWebsite, destination: websiteURL)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct DetailItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}
