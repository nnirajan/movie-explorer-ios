//
//  GenreLocalDataSource.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation
import SwiftData

// MARK: - GenreLocalDataSource
/// Concrete LocalDataSource implementation for Genre storage
/// Follows Dependency Inversion Principle - depends on ModelContainer abstraction
final class GenreLocalDataSource {
	// MARK: - Properties
	private let dataSource: SwiftDataLocalDataSource<GenreEntity>
	
	// MARK: - Initialization
	init(modelContainer: ModelContainer) {
		self.dataSource = SwiftDataLocalDataSource<GenreEntity>(
			modelContainer: modelContainer
		)
	}
	
	// MARK: - Public Methods
	
	/// Fetches all genres from local storage
	func fetchAllGenres() async throws -> [GenreEntity] {
		try await dataSource.fetchAll()
	}
	
	/// Fetches a single genre by ID
	func fetchGenreById(_ id: Int) async throws -> GenreEntity? {
		let predicate = #Predicate<GenreEntity> { genre in
			genre.id == id
		}
		let results = try await dataSource.fetch(where: predicate)
		return results.first
	}
	
	/// Saves multiple genres (batch operation)
	func saveGenres(_ genres: [GenreEntity]) async throws {
		try await dataSource.save(genres)
	}
	
	/// Saves a single genre
	func saveGenre(_ genre: GenreEntity) async throws {
		try await dataSource.save(genre)
	}
	
	/// Updates an existing genre
	func updateGenre(_ genre: GenreEntity) async throws {
		try await dataSource.update(genre)
	}
	
	/// Deletes a specific genre
	func deleteGenre(_ genre: GenreEntity) async throws {
		try await dataSource.delete(genre)
	}
	
	/// Deletes all genres from local storage
	func deleteAllGenres() async throws {
		try await dataSource.deleteAll()
	}
	
	/// Checks if a genre exists by ID
	func genreExists(_ id: Int) async -> Bool {
		do {
			let genre = try await fetchGenreById(id)
			return genre != nil
		} catch {
			return false
		}
	}
	
	/// Returns the total count of cached genres
	func getGenreCount() async throws -> Int {
		try await dataSource.count()
	}
}
