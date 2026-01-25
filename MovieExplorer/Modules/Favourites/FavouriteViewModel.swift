//
//  FavouriteViewModel.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

@Observable
final class FavouriteViewModel: BaseViewModel {
	// MARK: - Properties
	private let favouriteRepository: FavouriteRepository
	
	var movies: [Movie] = []
	
	// MARK: - Init
	init(favouriteRepository: FavouriteRepository) {
		self.favouriteRepository = favouriteRepository
		
		super.init()
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(loadFavourites),
			name: .favourite,
			object: nil
		)
	}
	
	@MainActor
	func getInitialData() {
		setLoading()
		loadFavourites()
	}
	
	@MainActor
	@objc func loadFavourites() {
		Task {
			do {
				movies = try await favouriteRepository.getFavourites()
				if movies.isEmpty {
					setEmpty()
				} else {
					setContent()
				}
			} catch {
				setError()
			}
		}
	}
}
