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
	private let localDataSource: FavouriteLocalDataSource
	private let mapper: FavouriteEntityMapper
	
	// MARK: - Initialization
	init(
		localDataSource: FavouriteLocalDataSource,
		mapper: FavouriteEntityMapper = FavouriteEntityMapper()
	) {
		self.localDataSource = localDataSource
		self.mapper = mapper
	}
	
	// MARK: - Add to favourite
	@MainActor
	func addToFavourite(_ movie: Movie) async throws {
		print("🎬 Adding to favourites: \(movie.title) (ID: \(movie.id))")
		
		// Check if already exists
		if await isFavourite(movieId: movie.id) {
			print("⚠️ Movie already in favourites: \(movie.title)")
			return
		}
		
		let entity = try mapper.toEntity(movie)
		try await localDataSource.saveFavourite(entity)
		
		print("✅ Successfully added to favourites: \(movie.title)")
	}
	
	// MARK: - Remove from favourite
	@MainActor
	func removeFromFavourite(movieId: Int) async throws {
		print("🗑️ Removing from favourites: ID \(movieId)")
		try await localDataSource.deleteFavourite(byId: movieId)
		print("✅ Successfully removed from favourites: ID \(movieId)")
	}
	
	// MARK: - Check if favourite
	@MainActor
	func isFavourite(movieId: Int) async -> Bool {
		await localDataSource.isFavourite(movieId)
	}
	
	// MARK: - Fetch all favourites
	@MainActor
	func getFavourites() async throws -> [Movie] {
		print("📚 Fetching all favourites...")
		let entities = try await localDataSource.fetchAllFavourites()
		let movies = try mapper.toDomains(entities)
		print("✅ Fetched \(movies.count) favourites")
		return movies
	}
}
