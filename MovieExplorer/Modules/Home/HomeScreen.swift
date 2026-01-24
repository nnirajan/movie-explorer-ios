//
//  HomeScreen.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import SwiftUI

struct HomeScreen: View {
	// MARK: - properties
	@State private var viewModel: HomeViewModel
	
	// MARK: - initialization
	init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
	}
	
	// MARK: - body
	var body: some View {
		BaseView(
			viewModel: viewModel,
			content: {
				ScrollView(.vertical) {
					if !viewModel.nowPlayingMovies.isEmpty {
						LazyVStack(alignment: .leading, spacing: 10) {
							Text("Now Showing")
								.font(AppTypography.largeTitle)
								.fontWeight(.semibold)
							
							ScrollView(.horizontal) {
								LazyHStack(spacing: 10) {
									ForEach(viewModel.nowPlayingMovies, id: \.id) { movie in
										VStack(alignment: .leading, spacing: 2) {
											CachedImageView(path: movie.posterPath)
												.cornerRadius(8)
												.frame(height: 212)
											
											Text(movie.title)
												.font(AppTypography.body)
												.lineLimit(2)
											
											RatingView(rating: movie.formattedRating)
										}
										.frame(width: 144, height: 280, alignment: .top)
									}
								}
							}
						}
					}
					
					if let popularMovies = viewModel.popularResponse?.results {
						LazyVStack(alignment: .leading, spacing: 10) {
							Text("Popular")
								.font(AppTypography.largeTitle)
								.fontWeight(.semibold)
							
							LazyVStack(spacing: 10) {
								ForEach(popularMovies, id: \.id) { movie in
									MovieListItemView(movie: movie, genres: viewModel.genres)
										.onAppear {
											if movie.id == popularMovies.last?.id {
												Task {
													await viewModel.getMorePopularMovies()
												}
											}
										}
								}
							}
							
							if viewModel.isFetchingMore {
								CircularLoaderView()
									.frame(maxWidth: .infinity)
							}
						}
					}
				}
				.scrollIndicators(.hidden)
				.safeAreaPadding(.horizontal)
				.safeAreaPadding(.bottom)
			},
			loadData: {
				viewModel.getInitialData()
			}
		)
	}
}

// MARK: - Preview
#Preview {
	HomeScreen(
		viewModel: HomeViewModel(
			movieRepository: MovieRepositoryImpl(
				networkClient: AppDependencyContainer.shared.networkClient
			)
		)
	)
}
