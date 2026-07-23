//
//  FavouriteLocalRepository.swift
//  MovieExplorer
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
	private let dataSource: FavouriteLocalDataSource
	private let mapper: FavouriteEntityMapper

	// MARK: - Initialization
	init(
		dataSource: FavouriteLocalDataSource,
		mapper: FavouriteEntityMapper = FavouriteEntityMapper()
	) {
		self.dataSource = dataSource
		self.mapper = mapper
	}

	// MARK: - FavouriteStore
	func fetchFavourites() async throws -> [Movie] {
		let entities = try await dataSource.fetchAllFavourites()
		return try mapper.toDomains(entities)
	}

	func saveFavourite(_ movie: Movie) async throws {
		let entity = try mapper.toEntity(movie)
		try await dataSource.saveFavourite(entity)
	}

	func deleteFavourite(movieId: Int) async throws {
		try await dataSource.deleteFavourite(byId: movieId)
	}

	func isFavourite(movieId: Int) async -> Bool {
		await dataSource.isFavourite(movieId)
	}
}
