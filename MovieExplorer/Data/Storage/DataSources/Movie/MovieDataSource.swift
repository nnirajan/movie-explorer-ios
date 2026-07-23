//
//  MovieDataSource.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation
import SwiftData

// MARK: - MovieDataSource
protocol MovieDataSource {
	func fetchMovies(byCategory category: MovieCategory) async throws -> [MovieEntity]
	func saveMovies(_ movies: [MovieEntity]) async throws
	func saveMovie(_ movie: MovieEntity) async throws
	func updateMovie(_ movie: MovieEntity) async throws
	func deleteMovies(byCategory category: MovieCategory) async throws
	func deleteAllMovies() async throws
	func movieExists(_ id: Int, category: MovieCategory) async -> Bool
}

// MARK: - MovieDataSourceImpl
final class MovieDataSourceImpl: MovieDataSource {
	// MARK: - Properties
	private let dataSource: SwiftDataLocalDataSource<MovieEntity>

	// MARK: - Initialization
	init(modelContainer: ModelContainer) {
		self.dataSource = SwiftDataLocalDataSource<MovieEntity>(modelContainer: modelContainer)
	}

	// MARK: - MovieDataSource
	func fetchMovies(byCategory category: MovieCategory) async throws -> [MovieEntity] {
		let rawCategory = category.rawValue
		let predicate = #Predicate<MovieEntity> { $0.category == rawCategory }
		return try await dataSource.fetch(where: predicate)
	}

	func saveMovies(_ movies: [MovieEntity]) async throws {
		try await dataSource.save(movies)
	}

	func saveMovie(_ movie: MovieEntity) async throws {
		try await dataSource.save(movie)
	}

	func updateMovie(_ movie: MovieEntity) async throws {
		try await dataSource.update(movie)
	}

	func deleteMovies(byCategory category: MovieCategory) async throws {
		let rawCategory = category.rawValue
		let predicate = #Predicate<MovieEntity> { $0.category == rawCategory }
		try await dataSource.delete(where: predicate)
	}

	func deleteAllMovies() async throws {
		try await dataSource.deleteAll()
	}

	func movieExists(_ id: Int, category: MovieCategory) async -> Bool {
		let rawCategory = category.rawValue
		let predicate = #Predicate<MovieEntity> { $0.movieId == id && $0.category == rawCategory }
		return (try? await dataSource.fetch(where: predicate).first) != nil
	}
}
