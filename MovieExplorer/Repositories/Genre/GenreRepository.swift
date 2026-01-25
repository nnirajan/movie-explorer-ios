//
//  GenreRepository.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import Foundation

protocol GenreRepository {
	func getGenres(request: NetworkRequest) async throws -> GenreReponse
}

class GenreRepositoryImpl: GenreRepository {
	// MARK: - Properties
	private let networkClient: NetworkClientProtocol
	private let localRepository: GenreLocalRepository
	
	// MARK: - Initialization
	init(
		networkClient: NetworkClientProtocol,
		localRepository: GenreLocalRepository
	) {
		self.networkClient = networkClient
		self.localRepository = localRepository
	}
	
	// MARK: - getGenres
	/// 1. Try to fetch from network
	/// 2. If successful, cache the data
	/// 3. If network fails, return cached data (offline support)
	func getGenres(request: NetworkRequest) async throws -> GenreReponse {
		do {
			let response: GenreReponse = try await networkClient.execute(request)
			try? await localRepository.saveGenres(response.genres)
			return response
		} catch {
			if let cachedGenres = try? await localRepository.fetchGenres(),
			   !cachedGenres.isEmpty {
				print("📦 Network failed, using cached genres")
				return GenreReponse(genres: cachedGenres)
			}
			
			throw error
		}
	}
}
