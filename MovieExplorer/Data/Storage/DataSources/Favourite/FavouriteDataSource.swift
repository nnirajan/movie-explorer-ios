//
//  FavouriteDataSource.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation
import SwiftData

// MARK: - FavouriteDataSource
protocol FavouriteDataSource {
	func fetchAllFavourites() async throws -> [FavouriteMovieEntity]
	func saveFavourite(_ entity: FavouriteMovieEntity) async throws
	func deleteFavourite(byId id: Int) async throws
	func isFavourite(_ id: Int) async -> Bool
}

// MARK: - FavouriteDataSourceImpl
final class FavouriteDataSourceImpl: FavouriteDataSource {
	// MARK: - Properties
	private let dataSource: SwiftDataLocalDataSource<FavouriteMovieEntity>

	// MARK: - Initialization
	init(modelContainer: ModelContainer) {
		self.dataSource = SwiftDataLocalDataSource<FavouriteMovieEntity>(modelContainer: modelContainer)
	}

	// MARK: - FavouriteDataSource
	func fetchAllFavourites() async throws -> [FavouriteMovieEntity] {
		try await dataSource.fetchAll()
	}

	func saveFavourite(_ entity: FavouriteMovieEntity) async throws {
		try await dataSource.save(entity)
	}

	func deleteFavourite(byId id: Int) async throws {
		let predicate = #Predicate<FavouriteMovieEntity> { $0.id == id }
		guard let entity = try await dataSource.fetch(where: predicate).first else { return }
		try await dataSource.delete(entity)
	}

	func isFavourite(_ id: Int) async -> Bool {
		let predicate = #Predicate<FavouriteMovieEntity> { $0.id == id }
		return (try? await dataSource.fetch(where: predicate).first) != nil
	}
}
