//
//  MovieRepository.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import Foundation

protocol MovieRepository {
	func getNowPlayingMovies(request: NetworkRequest) async throws -> MovieResponse
	func getPopularMovies(request: NetworkRequest) async throws -> MovieResponse
	func getGenres(request: NetworkRequest) async throws -> GenreReponse
}

class MovieRepositoryImpl: MovieRepository {
	// MARK: - properties
	private let networkClient: NetworkClientProtocol
	
	// MARK: - init
	init(
		networkClient: NetworkClientProtocol
	) {
		self.networkClient = networkClient
	}
	
	// MARK: - getNowPlayingMovies
	func getNowPlayingMovies(request: NetworkRequest) async throws -> MovieResponse {
		return try await networkClient.execute(request)
	}
	
	// MARK: - getNowPlayingMovies
	func getPopularMovies(request: NetworkRequest) async throws -> MovieResponse {
		return try await networkClient.execute(request)
	}
	
	// MARK: - getGenres
	func getGenres(request: NetworkRequest) async throws -> GenreReponse {
		return try await networkClient.execute(request)
		
//		let response: GenreResponse = try await networkClient.execute(request)
//		return response.genres
	}
}
