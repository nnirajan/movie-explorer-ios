//
//  DashboardScreen.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import SwiftUI

enum DashboardTab: String {
	case home, favorites
	
	var title: String {
		switch self {
		case .home: return "Home"
		case .favorites: return "Favourites"
		}
	}
	
	var icon: String {
		switch self {
		case .home: return "house.fill"
		case .favorites: return "heart.fill"
		}
	}
}

// Define routes for Home tab
enum DashBoardRoute: Route {
	case home
	case favourites
	case movieDetail(id: Int)
	case search

	var id: String {
		switch self {
		case .home:
			return "home"
		case .favourites:
			return "favourites"
		case .movieDetail(let id):
			return "detail_\(id)"
		case .search:
			return "search"
		}
	}
}

struct DashboardScreen: View {
	@State private var tabSelection: DashboardTab = .home
	
	@State private var dashboardRouter = Router<DashBoardRoute>()
	
	var navigationTitle: String {
		tabSelection == .home ? "" : "Favourites"
	}
	
	var body: some View {
		NavigationStackRouter(
			router: dashboardRouter,
			root: { _ in
				TabView(selection: $tabSelection) {
					Tab(
						DashboardTab.home.title,
						systemImage: DashboardTab.home.icon,
						value: .home,
						content: {
							HomeScreen(
								viewModel: AppDependencyContainer.shared.makeHomeViewModel(),
								router: dashboardRouter
							)
						}
					)
					
					Tab(
						DashboardTab.favorites.title,
						systemImage: DashboardTab.favorites.icon,
						value: .favorites,
						content: {
							FavouritesScreen(
								viewModel: AppDependencyContainer.shared.makeFavouriteViewModel(),
								router: dashboardRouter
							)
						}
					)
				}
				.toolbar {
					if tabSelection == .home {
						ToolbarItem(placement: .topBarTrailing) {
							Button {
								dashboardRouter.push(.search)
							} label: {
								Image(systemName: "magnifyingglass")
							}
						}
					}
				}
				.navigationTitle(navigationTitle)
				.navigationBarTitleDisplayMode(.inline)
			},
			destination: { (route, router) in
				handleDashboardRoutes(for: route, router: router)
			}
		)
	}
	
	@ViewBuilder
	private func handleDashboardRoutes(for route: DashBoardRoute, router: Router<DashBoardRoute>) -> some View {
		switch route {
		case .home:
			EmptyView()
			
		case .favourites:
			EmptyView()
			
		case .movieDetail(let id):
			DetailScreen(
				viewModel: AppDependencyContainer.shared.makeDetailViewModel(movieID: id)
			)
			
		case .search:
			SearchScreen(
				viewModel: SearchViewModel(
					searchRepository: SearchRepositoryImpl(
						networkClient: AppDependencyContainer.shared.networkClient
					)
				),
				router: router
			)
		}
	}
}

#Preview {
	DashboardScreen()
}
