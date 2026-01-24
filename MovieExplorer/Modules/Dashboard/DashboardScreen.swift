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

	var id: String {
		switch self {
		case .home:
			return "home"
		case .favourites:
			return "favourites"
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
									)
								)
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
				
			}
		)
		.navigationBarTitleDisplayMode(.inline)
		
	}
}

#Preview {
	DashboardScreen()
}
