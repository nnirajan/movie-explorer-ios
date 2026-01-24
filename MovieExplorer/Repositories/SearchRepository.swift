//
//  SearchRepository.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

protocol SearchRepository {
	func getSearchMovies(request: NetworkRequest) async throws -> MovieResponse
}

class SearchRepositoryImpl: SearchRepository {
	// MARK: - properties
	private let networkClient: NetworkClientProtocol
	
	// MARK: - init
	init(
		networkClient: NetworkClientProtocol
	) {
		self.networkClient = networkClient
	}
	
	// MARK: - getNowPlayingMovies
	func getSearchMovies(request: NetworkRequest) async throws -> MovieResponse {
		return try await networkClient.execute(request)
	}
}
