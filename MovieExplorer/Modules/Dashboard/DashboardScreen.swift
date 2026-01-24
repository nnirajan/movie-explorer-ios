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

	var id: String {
		switch self {
		case .home:
			return "home"
		case .favourites:
			return "favourites"
		case .movieDetail(let id):
			return "detail_\(id)"
			
		}
	}
}

struct DashboardScreen: View {
	@State private var tabSelection: DashboardTab = .home
	
	@State private var dashboardRouter = Router<DashBoardRoute>()
	
	var body: some View {
		NavigationStackRouter(
			router: dashboardRouter,
			root: { router in
				TabView(selection: $tabSelection) {
					Tab(
						DashboardTab.home.title,
						systemImage: DashboardTab.home.icon,
						value: .home,
						content: {
							HomeScreen(
								viewModel: HomeViewModel(
									movieRepository: MovieRepositoryImpl(
										networkClient: AppDependencyContainer.shared.networkClient
									),
									genreRepository: GenreRepositoryImpl(
										networkClient: AppDependencyContainer.shared.networkClient
									)
								),
								router: dashboardRouter
							)
						}
					)
					
					Tab(
						DashboardTab.favorites.title,
						systemImage: DashboardTab.favorites.icon,
						value: .home,
						content: {
							FavouritesScreen()
						}
					)
				}
			},
			destination: { (route, router) in
				handleDashboardRoutes(for: route, router: router)
			}
		)
		.navigationBarTitleDisplayMode(.inline)
		
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
				viewModel: DetailViewModel(
					movieID: id,
					movieRepository: MovieRepositoryImpl(
						networkClient: AppDependencyContainer.shared.networkClient
					)
				)
			)
		}
	}
	
	
	// MARK: - Home Destinations
	@ViewBuilder
	private func homeDestination(for route: HomeRoute, router: Router<HomeRoute>) -> some View {
		switch route {
		case .home:
			HomeTabView(router: router)
		case .detail(let id):
			DetailView(id: id, router: router)
		case .nestedDetail(let id, let subId):
			NestedDetailView(id: id, subId: subId, router: router)
		}
	}
}

#Preview {
	DashboardScreen()
}
