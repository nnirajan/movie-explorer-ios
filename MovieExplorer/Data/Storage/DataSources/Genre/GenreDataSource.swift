//
//  GenreDataSource.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation
import SwiftData

// MARK: - GenreDataSource
protocol GenreDataSource {
	func fetchAllGenres() async throws -> [GenreEntity]
	func saveGenres(_ genres: [GenreEntity]) async throws
	func deleteAllGenres() async throws
}

// MARK: - GenreDataSourceImpl
final class GenreDataSourceImpl: GenreDataSource {
	// MARK: - Properties
	private let dataSource: SwiftDataLocalDataSource<GenreEntity>

	// MARK: - Initialization
	init(modelContainer: ModelContainer) {
		self.dataSource = SwiftDataLocalDataSource<GenreEntity>(modelContainer: modelContainer)
	}

	// MARK: - GenreDataSource
	func fetchAllGenres() async throws -> [GenreEntity] {
		try await dataSource.fetchAll()
	}

	func saveGenres(_ genres: [GenreEntity]) async throws {
		try await dataSource.save(genres)
	}

	func deleteAllGenres() async throws {
		try await dataSource.deleteAll()
	}
}
