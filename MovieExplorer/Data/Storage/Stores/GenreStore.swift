//
//  GenreStore.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

// MARK: - GenreStore
protocol GenreStore {
	func fetchGenres() async throws -> [Genre]
	func saveGenres(_ genres: [Genre]) async throws
}

// MARK: - GenreStoreImpl
final class GenreStoreImpl: GenreStore {
	// MARK: - Properties
	private let dataSource: GenreDataSource

	// MARK: - Initialization
	init(dataSource: GenreDataSource) {
		self.dataSource = dataSource
	}

	// MARK: - GenreStore
	func fetchGenres() async throws -> [Genre] {
		let entities = try await dataSource.fetchAllGenres()
		return GenreEntityMapper.toDomains(entities)
	}

	func saveGenres(_ genres: [Genre]) async throws {
		try await dataSource.deleteAllGenres()
		let entities = GenreEntityMapper.toEntities(genres)
		try await dataSource.saveGenres(entities)
	}
}
