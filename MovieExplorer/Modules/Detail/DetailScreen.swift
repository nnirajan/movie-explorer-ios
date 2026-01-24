//
//  DetailScreen.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import SwiftUI

struct DetailScreen: View {
	// MARK: - properties
	@State private var viewModel: DetailViewModel
	
	// MARK: - initialization
	init(viewModel: DetailViewModel) {
		self.viewModel = viewModel
	}
	
	// MARK: - body
	var body: some View {
		BaseView(
			viewModel: viewModel,
			content: {
				ScrollView(.vertical) {
					if let movie = viewModel.movie {
						LazyVStack(alignment: .leading, spacing: 12) {
							ZStack(alignment: .top) {
								CachedImageView(path: movie.backdropPath, size: .original)
									.frame(height: 280)
									.cornerRadius(12, corners: [.bottomLeft, .bottomRight])
								
								HStack(alignment: .top, spacing: 8) {
									CachedImageView(path: movie.posterPath, size: .original)
										.frame(width: 144, height: 212)
										.cornerRadius(8)
										.shadow(radius: 5)
									
									VStack(alignment: .leading, spacing: 10) {
										Text(movie.title)
											.font(AppTypography.title)
											.fixedSize(horizontal: false, vertical: true)
										
										RatingView(rating: movie.formattedRating)
									}
									.padding(.top, 106)
								}
								.padding(.top, 180)
								.frame(maxWidth: .infinity, alignment: .leading)
								.padding(.horizontal, 16)
							}
							
							HStack(alignment: .center, spacing: 12) {
								ReleaseDateView(releaseDate: movie.formattedReleaseDate)
								
								Rectangle()
									.frame(width: 2, height: 20)
									.foregroundStyle(.secondary)
								
								RunTimeView(runtime: movie.runtime ?? 0)
							}
							.frame(maxWidth: .infinity, alignment: .center)
							
							if let genres = movie.genres {
								FlowLayout(horizontalSpacing: 6, verticalSpacing: 6, alignment: .center) {
									ForEach(genres, id: \.id) { genre in
										ChipView(
											text: genre.name ?? "",
										)
									}
								}
							}
							
							VStack(alignment: .leading, spacing: 10) {
								Text("Overview")
									.font(AppTypography.largeTitle)
									.fontWeight(.semibold)
								
								Text(movie.overview)
									.font(AppTypography.body)
							}
							.padding(.horizontal, 16)
							
							if !viewModel.cast.isEmpty {
								VStack(alignment: .leading, spacing: 10) {
									Text("Casts")
										.font(AppTypography.largeTitle)
										.fontWeight(.semibold)
									
									ScrollView(.horizontal) {
										LazyHStack {
											ForEach(viewModel.cast, id: \.id) { cast in
												VStack(alignment: .leading) {
													CachedImageView(path: cast.profilePath ?? "", size: .original)
														.frame(width: 100, height: 100)
														.cornerRadius(12, corners: .allCorners)
													
													Text(cast.name)
														.font(AppTypography.body)
														.frame(height: 50, alignment: .top)
												}
												.frame(width: 100, alignment: .top)
											}
										}
									}
								}
								.padding(.horizontal, 16)
							}
						}
					}
				}
				.scrollIndicators(.hidden)
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
	DetailScreen(
		viewModel: DetailViewModel(
			movieID: 991494,
			movieRepository: MovieRepositoryImpl(
				networkClient: AppDependencyContainer.shared.networkClient
			)
		)
	)
}
