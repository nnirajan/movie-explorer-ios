//
//  FavouriteLocalDataSource.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation
import SwiftData

final class FavouriteLocalDataSource {
	private let dataSource: SwiftDataLocalDataSource<FavouriteMovieEntity>

	init(modelContainer: ModelContainer) {
		self.dataSource = SwiftDataLocalDataSource<FavouriteMovieEntity>(
			modelContainer: modelContainer
		)
	}

	@MainActor
	func fetchAllFavourites() async throws -> [FavouriteMovieEntity] {
		try await dataSource.fetchAll()
	}

	@MainActor
	func fetchFavourite(byId id: Int) async throws -> FavouriteMovieEntity? {
		let predicate = #Predicate<FavouriteMovieEntity> { $0.id == id }
		let results = try await dataSource.fetch(where: predicate)
		return results.first
	}

	@MainActor
	func saveFavourite(_ movie: FavouriteMovieEntity) async throws {
		// Check if already exists before saving
		if let existing = try? await fetchFavourite(byId: movie.id) {
			print("⚠️ Favourite already exists with ID: \(movie.id)")
			return
		}
		
		try await dataSource.save(movie)
		
		// Verify save with detailed logging
		let count = try await dataSource.count()
		print("✅ Total favourites after save: \(count)")
		
		let all = try await fetchAllFavourites()
		print("✅ All favourites: \(all.map { "\($0.title) (ID: \($0.id))" })")
	}

	func deleteFavourite(byId id: Int) async throws {
		guard let entity = try await fetchFavourite(byId: id) else {
			print("⚠️ No favourite found with ID: \(id)")
			return
		}
		
		try await dataSource.delete(entity)
		
		// Verify deletion
		let count = try await dataSource.count()
		print("✅ Total favourites after delete: \(count)")
	}

	@MainActor
	func isFavourite(_ id: Int) async -> Bool {
		do {
			let result = try await fetchFavourite(byId: id)
			return result != nil
		} catch {
			return false
		}
	}

	@MainActor
	func getFavouriteCount() async throws -> Int {
		try await dataSource.count()
	}
}
