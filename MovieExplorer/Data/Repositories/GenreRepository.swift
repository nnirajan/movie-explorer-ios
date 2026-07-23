//
//  GenreRepository.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import Foundation

protocol GenreRepository {
	func getGenres(request: NetworkRequest) async throws -> GenreResponse
}

final class GenreRepositoryImpl: GenreRepository {
	// MARK: - Properties
	private let networkClient: NetworkClientProtocol
	private let store: GenreStore

	// MARK: - Initialization
	init(
		networkClient: NetworkClientProtocol,
		store: GenreStore
	) {
		self.networkClient = networkClient
		self.store = store
	}
	
	// MARK: - getGenres
	/// 1. Try to fetch from network
	/// 2. If successful, cache the data
	/// 3. If network fails, return cached data (offline support)
	func getGenres(request: NetworkRequest) async throws -> GenreResponse {
		do {
			let response: GenreResponse = try await networkClient.execute(request)
			try? await store.saveGenres(response.genres)
			return response
		} catch {
			if let cachedGenres = try? await store.fetchGenres(),
			   !cachedGenres.isEmpty {
				print("📦 Network failed, using cached genres")
				return GenreResponse(genres: cachedGenres)
			}
			
			throw error
		}
	}
}
