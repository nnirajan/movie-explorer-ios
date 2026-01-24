//
//  SearchScreen.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import SwiftUI

struct SearchScreen: View {
	@State private var viewModel: SearchViewModel
	let router: Router<DashBoardRoute>
	
	init(viewModel: SearchViewModel, router: Router<DashBoardRoute>) {
		self.viewModel = viewModel
		self.router = router
	}
	
	var body: some View {
		BaseView(
			viewModel: viewModel,
			isRefreshable: false,
			content: {
				ScrollView(.vertical) {
					PaginationStateView(
						state: viewModel.searchState,
						items: viewModel.movies,
						content: { (movies, hasMore, isFetchingMore) in
							PaginatedListView(
								items: movies,
								hasMore: hasMore,
								isFetchingMore: isFetchingMore,
								itemView: { movie in
									MovieListItemView(movie: movie, genres: [])
										.contentShape(Rectangle())
										.onTapGesture {
											router.push(.movieDetail(id: movie.id))
										}
								},
								onLoadMore: {
									Task {
										await viewModel.performSearch(loadMore: true)
									}
								}
							)
						},
						emptyView: {
							PlaceholderView(
								icon: "film.stack",
								title: "No Movies Found",
								message: "Try searching with different keywords"
							)
						}
					)
				}
				.scrollIndicators(.hidden)
				.safeAreaPadding(.horizontal)
				.safeAreaPadding(.bottom)
			},
			loadData: { }
		)
		.navigationTitle("Search")
		.navigationBarTitleDisplayMode(.inline)
		.searchable(
			text: $viewModel.searchText,
			placement: .navigationBarDrawer(displayMode: .always),
			prompt: "Search movies"
		)
		.onChange(of: viewModel.searchText) { _, newValue in
			viewModel.handleSearchTextChange(newValue)
		}
	}
}

#Preview {
	DashboardScreen()
}
