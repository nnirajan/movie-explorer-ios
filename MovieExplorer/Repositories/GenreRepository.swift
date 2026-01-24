//
//  GenreRepository.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

protocol GenreRepository {
	func getGenres(request: NetworkRequest) async throws -> GenreReponse
}

class GenreRepositoryImpl: GenreRepository {
	// MARK: - properties
	private let networkClient: NetworkClientProtocol
	
	// MARK: - init
	init(
		networkClient: NetworkClientProtocol
	) {
		self.networkClient = networkClient
	}
	
	// MARK: - getGenres
	func getGenres(request: NetworkRequest) async throws -> GenreReponse {
		return try await networkClient.execute(request)
		
//		let response: GenreResponse = try await networkClient.execute(request)
//		return response.genres
	}
}
