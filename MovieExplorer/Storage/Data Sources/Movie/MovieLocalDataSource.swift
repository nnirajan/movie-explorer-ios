//
//  MovieLocalDataSource.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation
import SwiftData

// MARK: - MovieCategory
enum MovieCategory: String {
	case nowPlaying = "now_playing"
	case popular = "popular"
	case detail = "detail"
}

// MARK: - MovieLocalDataSource
final class MovieLocalDataSource {
	// MARK: - Properties
	private let dataSource: SwiftDataLocalDataSource<MovieEntity>
	
	// MARK: - Initialization
	init(modelContainer: ModelContainer) {
		self.dataSource = SwiftDataLocalDataSource<MovieEntity>(
			modelContainer: modelContainer
		)
	}
	
	// MARK: - Public Methods
	
	/// Fetches all movies from local storage
	func fetchAllMovies() async throws -> [MovieEntity] {
		try await dataSource.fetchAll()
	}
	
	/// Fetches movies by category (nowPlaying, popular, detail)
	func fetchMovies(byCategory category: MovieCategory) async throws -> [MovieEntity] {
		let rawCategory = category.rawValue
		
		let predicate = #Predicate<MovieEntity> { movie in
			movie.category == rawCategory
		}
		return try await dataSource.fetch(where: predicate)
	}
	
	/// Fetches a single movie by ID
	func fetchMovieById(_ id: Int) async throws -> MovieEntity? {
		let predicate = #Predicate<MovieEntity> { movie in
			movie.id == id
		}
		let results = try await dataSource.fetch(where: predicate)
		return results.first
	}
	
	/// Fetches a single movie by ID and category
	func fetchMovie(byId id: Int, category: MovieCategory) async throws -> MovieEntity? {
		let rawCategory = category.rawValue
		
		let predicate = #Predicate<MovieEntity> { movie in
			movie.id == id && movie.category == rawCategory
		}
		let results = try await dataSource.fetch(where: predicate)
		return results.first
	}
	
	/// Fetches movies by IDs (useful for fetching specific categories)
	func fetchMoviesByIds(_ ids: [Int]) async throws -> [MovieEntity] {
		let predicate = #Predicate<MovieEntity> { movie in
			ids.contains(movie.id)
		}
		return try await dataSource.fetch(where: predicate)
	}
	
	/// Saves multiple movies (batch operation)
	func saveMovies(_ movies: [MovieEntity]) async throws {
		try await dataSource.save(movies)
	}
	
	/// Saves a single movie
	func saveMovie(_ movie: MovieEntity) async throws {
		try await dataSource.save(movie)
	}
	
	/// Updates an existing movie
	func updateMovie(_ movie: MovieEntity) async throws {
		try await dataSource.update(movie)
	}
	
	/// Deletes a specific movie
	func deleteMovie(_ movie: MovieEntity) async throws {
		try await dataSource.delete(movie)
	}
	
	/// Deletes all movies of a specific category
	func deleteMovies(byCategory category: MovieCategory) async throws {
		let rawCategory = category.rawValue
		
		let predicate = #Predicate<MovieEntity> { movie in
			movie.category == rawCategory
		}
		try await dataSource.delete(where: predicate)
	}
	
	/// Deletes movies by IDs
	func deleteMoviesByIds(_ ids: [Int]) async throws {
		let predicate = #Predicate<MovieEntity> { movie in
			ids.contains(movie.id)
		}
		try await dataSource.delete(where: predicate)
	}
	
	/// Deletes all movies from local storage
	func deleteAllMovies() async throws {
		try await dataSource.deleteAll()
	}
	
	/// Checks if a movie exists by ID
	func movieExists(_ id: Int) async -> Bool {
		do {
			let movie = try await fetchMovieById(id)
			return movie != nil
		} catch {
			return false
		}
	}
	
	/// Checks if a movie exists by ID and category
	func movieExists(_ id: Int, category: MovieCategory) async -> Bool {
		do {
			let movie = try await fetchMovie(byId: id, category: category)
			return movie != nil
		} catch {
			return false
		}
	}
	
	/// Returns the total count of cached movies
	func getMovieCount() async throws -> Int {
		try await dataSource.count()
	}
	
	/// Returns count of movies in a specific category
	func getMovieCount(forCategory category: MovieCategory) async throws -> Int {
		let rawCategory = category.rawValue
		
		let predicate = #Predicate<MovieEntity> { movie in
			movie.category == rawCategory
		}
		return try await dataSource.count(where: predicate)
	}
	
	/// Fetches movies sorted by creation date (most recent first)
	func fetchRecentMovies(limit: Int) async throws -> [MovieEntity] {
		let sortDescriptor = SortDescriptor(\MovieEntity.createdAt, order: .reverse)
		return try await dataSource.fetch(
			sortBy: [sortDescriptor],
			where: nil
		)
	}
	
	/// Fetches recent movies by category
	func fetchRecentMovies(limit: Int, category: MovieCategory) async throws -> [MovieEntity] {
		let rawCategory = category.rawValue
		
		let predicate = #Predicate<MovieEntity> { movie in
			movie.category == rawCategory
		}
		
//		let sortDescriptor = SortDescriptor(\MovieEntity.createdAt, order: .reverse)
		
		return try await dataSource.fetch(
			limit: limit,
			offset: 0,
			where: predicate
		)
	}
}
