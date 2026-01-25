//
//  GenreLocalRepository.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

final class GenreLocalRepository {
	// MARK: - Properties
	private let dataSource: GenreLocalDataSource
	private let mapper: GenreEntityMapper
	
	// MARK: - Initialization
	init(
		dataSource: GenreLocalDataSource,
		mapper: GenreEntityMapper = GenreEntityMapper()
	) {
		self.dataSource = dataSource
		self.mapper = mapper
	}
	
	// MARK: - Public Methods

	/// Fetches all cached genres from local storage
	/// - Returns: Array of Genre domain models
	/// - Throws: StorageError if fetch or mapping fails
	func fetchGenres() async throws -> [Genre] {
		let entities = try await dataSource.fetchAllGenres()
		return try mapper.toDomains(entities)
	}
	
	/// Fetches a single genre by ID
	/// - Parameter id: Genre identifier
	/// - Returns: Genre domain model if found, nil otherwise
	/// - Throws: StorageError if fetch or mapping fails
	func fetchGenre(byId id: Int) async throws -> Genre? {
		guard let entity = try await dataSource.fetchGenreById(id) else {
			return nil
		}
		return try mapper.toDomain(entity)
	}
	
	/// Saves genres to local storage (replaces existing)
	/// - Parameter genres: Array of Genre domain models to cache
	/// - Throws: StorageError if mapping or save fails
	func saveGenres(_ genres: [Genre]) async throws {
		// First delete all existing genres (replace strategy)
		try await dataSource.deleteAllGenres()
		
		// Map and save new genres
		let entities = try mapper.toEntities(genres)
		try await dataSource.saveGenres(entities)
	}
	
	/// Saves or updates a single genre
	/// - Parameter genre: Genre domain model to save
	/// - Throws: StorageError if mapping or save fails
	func saveGenre(_ genre: Genre) async throws {
		let entity = try mapper.toEntity(genre)
		
		// Check if genre already exists
		if await dataSource.genreExists(entity.id) {
			try await dataSource.updateGenre(entity)
		} else {
			try await dataSource.saveGenre(entity)
		}
	}
	
	/// Deletes a specific genre by ID
	/// - Parameter id: Genre identifier
	/// - Throws: StorageError if delete fails
	func deleteGenre(byId id: Int) async throws {
		guard let entity = try await dataSource.fetchGenreById(id) else {
			return // Genre doesn't exist, nothing to delete
		}
		try await dataSource.deleteGenre(entity)
	}
	
	/// Clears all cached genres from local storage
	/// - Throws: StorageError if delete fails
	func clearGenres() async throws {
		try await dataSource.deleteAllGenres()
	}
	
	/// Checks if local cache has genres
	/// - Returns: True if cache has data, false otherwise
	func hasCachedGenres() async -> Bool {
		do {
			let count = try await dataSource.getGenreCount()
			return count > 0
		} catch {
			return false
		}
	}
	
	/// Returns the number of cached genres
	/// - Returns: Count of genres in local storage
	func getGenreCount() async throws -> Int {
		try await dataSource.getGenreCount()
	}
}
