//
//  DashboardScreen.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import SwiftUI

enum DashboardTab: String {
	case home, favourites
	
	var title: String {
		switch self {
		case .home: return "Home"
		case .favourites: return "Favourites"
		}
	}
	
	var icon: String {
		switch self {
		case .home: return "house.fill"
		case .favourites: return "heart.fill"
		}
	}
}

// Define routes for Home tab
enum DashboardRoute: Route {
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
	private let container: AppDependencyContainer

	@State private var tabSelection: DashboardTab = .home
	@State private var dashboardRouter = Router<DashboardRoute>()

	init(container: AppDependencyContainer) {
		self.container = container
	}
	
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
								viewModel: container.makeHomeViewModel(),
								router: dashboardRouter
							)
						}
					)
					
					Tab(
						DashboardTab.favourites.title,
						systemImage: DashboardTab.favourites.icon,
						value: .favourites,
						content: {
							FavouritesScreen(
								viewModel: container.makeFavouriteViewModel(),
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
	private func handleDashboardRoutes(for route: DashboardRoute, router: Router<DashboardRoute>) -> some View {
		switch route {
		case .home:
			EmptyView()
			
		case .favourites:
			EmptyView()
			
		case .movieDetail(let id):
			DetailScreen(
				viewModel: container.makeDetailViewModel(movieID: id)
			)
			
		case .search:
			SearchScreen(
				viewModel: container.makeSearchViewModel(),
				router: router
			)
		}
	}
}

#Preview {
	DashboardScreen(container: AppDependencyContainer())
}
