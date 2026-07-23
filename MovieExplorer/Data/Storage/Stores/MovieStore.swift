//
//  MovieStore.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

// MARK: - MovieStore
protocol MovieStore {
	func fetchMovies(byCategory category: MovieCategory) async throws -> [Movie]
	func replaceMovies(_ movies: [Movie], category: MovieCategory) async throws
	func saveMovies(_ movies: [Movie], category: MovieCategory) async throws
	func saveMovie(_ movie: Movie, category: MovieCategory) async throws
	func deleteMovies(byCategory category: MovieCategory) async throws
	func clearMovies() async throws
}

// MARK: - MovieStoreImpl
final class MovieStoreImpl: MovieStore {
	// MARK: - Properties
	private let dataSource: MovieDataSource

	// MARK: - Initialization
	init(dataSource: MovieDataSource) {
		self.dataSource = dataSource
	}

	// MARK: - MovieStore
	func fetchMovies(byCategory category: MovieCategory) async throws -> [Movie] {
		let entities = try await dataSource.fetchMovies(byCategory: category)
		return MovieEntityMapper.toDomains(entities)
	}

	func replaceMovies(_ movies: [Movie], category: MovieCategory) async throws {
		try await dataSource.deleteMovies(byCategory: category)
		let entities = MovieEntityMapper.toEntities(movies, category: category)
		try await dataSource.saveMovies(entities)
	}

	func saveMovies(_ movies: [Movie], category: MovieCategory) async throws {
		let entities = MovieEntityMapper.toEntities(movies, category: category)
		for entity in entities {
			if await dataSource.movieExists(entity.movieId, category: category) {
				try await dataSource.updateMovie(entity)
			} else {
				try await dataSource.saveMovie(entity)
			}
		}
	}

	func saveMovie(_ movie: Movie, category: MovieCategory) async throws {
		let entity = MovieEntityMapper.toEntity(movie, category: category)
		if await dataSource.movieExists(entity.movieId, category: category) {
			try await dataSource.updateMovie(entity)
		} else {
			try await dataSource.saveMovie(entity)
		}
	}

	func deleteMovies(byCategory category: MovieCategory) async throws {
		try await dataSource.deleteMovies(byCategory: category)
	}

	func clearMovies() async throws {
		try await dataSource.deleteAllMovies()
	}
}
