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
	
	let router: Router<DashBoardRoute>
	
	// MARK: - initialization
	init(
		viewModel: HomeViewModel,
		router: Router<DashBoardRoute>
	) {
		self.viewModel = viewModel
		self.router = router
	}
	
	// MARK: - body
	var body: some View {
		BaseView(
			viewModel: viewModel,
			isRefreshable: true,
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
										VStack(alignment: .leading, spacing: 4) {
											CachedImageView(path: movie.posterPath ?? "")
												.cornerRadius(8)
												.frame(height: 212)
											
											VStack(alignment: .leading, spacing: 4) {
												Text(movie.title)
													.font(AppTypography.body)
													.lineLimit(2)
												
												RatingView(rating: movie.formattedRating)
											}
											.padding(.horizontal, 2)
										}
										.frame(width: 144, height: 280, alignment: .top)
										.contentShape(Rectangle())
										.onTapGesture {
											router.push(.movieDetail(id: movie.id))
										}
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
										.contentShape(Rectangle())
										.onTapGesture {
											router.push(.movieDetail(id: movie.id))
										}
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
