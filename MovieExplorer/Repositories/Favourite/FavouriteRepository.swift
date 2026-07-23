//
//  FavouriteRepository.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

protocol FavouriteRepository {
	func addToFavourite(_ movie: Movie) async throws
	func removeFromFavourite(movieId: Int) async throws
	func isFavourite(movieId: Int) async -> Bool
	func getFavourites() async throws -> [Movie]
}

final class FavouriteRepositoryImpl: FavouriteRepository {

	// MARK: - Properties
	private let store: FavouriteStore

	// MARK: - Initialization
	init(store: FavouriteStore) {
		self.store = store
	}

	// MARK: - Add to favourite
	@MainActor
	func addToFavourite(_ movie: Movie) async throws {
		print("🎬 Adding to favourites: \(movie.title) (ID: \(movie.id))")

		if await isFavourite(movieId: movie.id) {
			print("⚠️ Movie already in favourites: \(movie.title)")
			return
		}

		try await store.saveFavourite(movie)
		print("✅ Successfully added to favourites: \(movie.title)")
	}

	// MARK: - Remove from favourite
	@MainActor
	func removeFromFavourite(movieId: Int) async throws {
		print("🗑️ Removing from favourites: ID \(movieId)")
		try await store.deleteFavourite(movieId: movieId)
		print("✅ Successfully removed from favourites: ID \(movieId)")
	}

	// MARK: - Check if favourite
	@MainActor
	func isFavourite(movieId: Int) async -> Bool {
		await store.isFavourite(movieId: movieId)
	}

	// MARK: - Fetch all favourites
	@MainActor
	func getFavourites() async throws -> [Movie] {
		print("📚 Fetching all favourites...")
		let movies = try await store.fetchFavourites()
		print("✅ Fetched \(movies.count) favourites")
		return movies
	}
}
