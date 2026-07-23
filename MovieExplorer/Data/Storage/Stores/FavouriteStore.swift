//
//  FavouriteStore.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

// MARK: - FavouriteStore
protocol FavouriteStore {
	func fetchFavourites() async throws -> [Movie]
	func saveFavourite(_ movie: Movie) async throws
	func deleteFavourite(movieId: Int) async throws
	func isFavourite(movieId: Int) async -> Bool
}

// MARK: - FavouriteStoreImpl
final class FavouriteStoreImpl: FavouriteStore {
	// MARK: - Properties
	private let dataSource: FavouriteDataSource

	// MARK: - Initialization
	init(dataSource: FavouriteDataSource) {
		self.dataSource = dataSource
	}

	// MARK: - FavouriteStore
	func fetchFavourites() async throws -> [Movie] {
		let entities = try await dataSource.fetchAllFavourites()
		return FavouriteEntityMapper.toDomains(entities)
	}

	func saveFavourite(_ movie: Movie) async throws {
		guard !(await isFavourite(movieId: movie.id)) else { return }
		let entity = FavouriteEntityMapper.toEntity(movie)
		try await dataSource.saveFavourite(entity)
	}

	func deleteFavourite(movieId: Int) async throws {
		try await dataSource.deleteFavourite(byId: movieId)
	}

	func isFavourite(movieId: Int) async -> Bool {
		await dataSource.isFavourite(movieId)
	}
}
