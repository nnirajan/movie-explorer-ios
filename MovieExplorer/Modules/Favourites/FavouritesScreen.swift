//
//  FavouritesScreen.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import SwiftUI

struct FavouritesScreen: View {
	@State private var viewModel: FavouriteViewModel
	let router: Router<DashBoardRoute>
	
	init(
		viewModel: FavouriteViewModel,
		router: Router<DashBoardRoute>
	) {
		self.viewModel = viewModel
		self.router = router
	}
	
	var body: some View {
		BaseView(
			viewModel: viewModel,
			isRefreshable: true,
			content: {
				ScrollView(.vertical) {
					ForEach(viewModel.movies, id: \.id) { movie in
						MovieListItemView(movie: movie, genres: [])
							.contentShape(Rectangle())
							.onTapGesture {
								router.push(.movieDetail(id: movie.id))
							}
					}
				}
				.scrollIndicators(.hidden)
				.safeAreaPadding(.horizontal)
				.safeAreaPadding(.bottom)
			},
			emptyView: {
				PlaceholderView(
					icon: "film.stack",
					title: "No Movies Found",
					message: "No Favourite Movies yet. Start browsing and adding them here."
				)
			},
			loadData: {
				viewModel.getInitialData()
			}
		)
	}
}

//#Preview {
//	FavouritesScreen(
//		viewModel: AppDependencyContainer.shared.makeFavouriteViewModel()
//	)
//}
