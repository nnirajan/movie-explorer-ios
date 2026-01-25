//
//  MovieLocalRepository.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

final class MovieLocalRepository {
	// MARK: - Properties
	private let dataSource: MovieLocalDataSource
	private let mapper: MovieEntityMapper
	
	// MARK: - Initialization
	init(
		dataSource: MovieLocalDataSource,
		mapper: MovieEntityMapper = MovieEntityMapper()
	) {
		self.dataSource = dataSource
		self.mapper = mapper
	}
	
	// MARK: - Public Methods
	
	/// Fetches all cached movies from local storage
	/// - Returns: Array of Movie domain models
	/// - Throws: StorageError if fetch or mapping fails
	func fetchMovies() async throws -> [Movie] {
		let entities = try await dataSource.fetchAllMovies()
		return try mapper.toDomains(entities)
	}
	
	/// Fetches movies by category
	/// - Parameter category: Movie category (nowPlaying, popular, detail)
	/// - Returns: Array of Movie domain models
	/// - Throws: StorageError if fetch or mapping fails
	func fetchMovies(byCategory category: MovieCategory) async throws -> [Movie] {
		let entities = try await dataSource.fetchMovies(byCategory: category)
		return try mapper.toDomains(entities)
	}
	
	/// Fetches a single movie by ID
	/// - Parameter id: Movie identifier
	/// - Returns: Movie domain model if found, nil otherwise
	/// - Throws: StorageError if fetch or mapping fails
	func fetchMovie(byId id: Int) async throws -> Movie? {
		guard let entity = try await dataSource.fetchMovieById(id) else {
			return nil
		}
		return try mapper.toDomain(entity)
	}
	
	/// Fetches movies by their IDs
	/// - Parameter ids: Array of movie identifiers
	/// - Returns: Array of Movie domain models
	/// - Throws: StorageError if fetch or mapping fails
	func fetchMovies(byIds ids: [Int]) async throws -> [Movie] {
		let entities = try await dataSource.fetchMoviesByIds(ids)
		return try mapper.toDomains(entities)
	}
	
	/// Saves movies to local storage with category (adds new, updates existing)
	/// - Parameters:
	///   - movies: Array of Movie domain models to cache
	///   - category: Category to assign to the movies
	/// - Throws: StorageError if mapping or save fails
	func saveMovies(_ movies: [Movie], category: MovieCategory) async throws {
		let entities = try mapper.toEntities(movies, category: category)
		
		// Check which movies already exist and update/insert accordingly
		for entity in entities {
			if await dataSource.movieExists(entity.id, category: category) {
				try await dataSource.updateMovie(entity)
			} else {
				try await dataSource.saveMovie(entity)
			}
		}
	}
	
	/// Replaces all movies in a category with new set
	/// - Parameters:
	///   - movies: Array of Movie domain models to cache
	///   - category: Category to replace
	/// - Throws: StorageError if mapping or save fails
	func replaceMovies(_ movies: [Movie], category: MovieCategory) async throws {
		try await dataSource.deleteMovies(byCategory: category)
		
		let entities = try mapper.toEntities(movies, category: category)
		try await dataSource.saveMovies(entities)
	}
	
	/// Saves or updates a single movie with category
	/// - Parameters:
	///   - movie: Movie domain model to save
	///   - category: Category to assign
	/// - Throws: StorageError if mapping or save fails
	func saveMovie(_ movie: Movie, category: MovieCategory) async throws {
		let entity = try mapper.toEntity(movie, category: category)
		
		// Check if movie already exists in this category
		if await dataSource.movieExists(entity.id, category: category) {
			try await dataSource.updateMovie(entity)
		} else {
			try await dataSource.saveMovie(entity)
		}
	}
	
	/// Deletes a specific movie by ID
	/// - Parameter id: Movie identifier
	/// - Throws: StorageError if delete fails
	func deleteMovie(byId id: Int) async throws {
		guard let entity = try await dataSource.fetchMovieById(id) else {
			return // Movie doesn't exist, nothing to delete
		}
		try await dataSource.deleteMovie(entity)
	}
	
	/// Deletes all movies in a specific category
	/// - Parameter category: Category to clear
	/// - Throws: StorageError if delete fails
	func deleteMovies(byCategory category: MovieCategory) async throws {
		try await dataSource.deleteMovies(byCategory: category)
	}
	
	/// Deletes movies by their IDs
	/// - Parameter ids: Array of movie identifiers
	/// - Throws: StorageError if delete fails
	func deleteMovies(byIds ids: [Int]) async throws {
		try await dataSource.deleteMoviesByIds(ids)
	}
	
	/// Clears all cached movies from local storage
	/// - Throws: StorageError if delete fails
	func clearMovies() async throws {
		try await dataSource.deleteAllMovies()
	}
	
	/// Checks if local cache has movies
	/// - Returns: True if cache has data, false otherwise
	func hasCachedMovies() async -> Bool {
		do {
			let count = try await dataSource.getMovieCount()
			return count > 0
		} catch {
			return false
		}
	}
	
	/// Checks if cache has movies for a specific category
	/// - Parameter category: Category to check
	/// - Returns: True if cache has data, false otherwise
	func hasCachedMovies(forCategory category: MovieCategory) async -> Bool {
		do {
			let count = try await dataSource.getMovieCount(forCategory: category)
			return count > 0
		} catch {
			return false
		}
	}
	
	/// Returns the number of cached movies
	/// - Returns: Count of movies in local storage
	func getMovieCount() async throws -> Int {
		try await dataSource.getMovieCount()
	}
	
	/// Returns count of movies in a specific category
	/// - Parameter category: Category to count
	/// - Returns: Count of movies in the category
	func getMovieCount(forCategory category: MovieCategory) async throws -> Int {
		try await dataSource.getMovieCount(forCategory: category)
	}
	
	/// Fetches recent movies (sorted by cache date)
	/// - Parameter limit: Maximum number of movies to fetch
	/// - Returns: Array of recently cached movies
	func fetchRecentMovies(limit: Int) async throws -> [Movie] {
		let entities = try await dataSource.fetchRecentMovies(limit: limit)
		return try mapper.toDomains(entities)
	}
	
	/// Fetches recent movies by category
	/// - Parameters:
	///   - limit: Maximum number of movies to fetch
	///   - category: Category to filter by
	/// - Returns: Array of recently cached movies in the category
	func fetchRecentMovies(limit: Int, category: MovieCategory) async throws -> [Movie] {
		let entities = try await dataSource.fetchRecentMovies(limit: limit, category: category)
		return try mapper.toDomains(entities)
	}
}
