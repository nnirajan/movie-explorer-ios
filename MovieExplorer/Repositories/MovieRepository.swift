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
	func getMovieDetail(request: NetworkRequest) async throws -> Movie
	func getCredits(request: NetworkRequest) async throws -> CastResponse
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
	
	// MARK: - getMovieDetail
	func getMovieDetail(request: any NetworkRequest) async throws -> Movie {
		return try await networkClient.execute(request)
	}
	
	// MARK: - getMovieDetail
	func getCredits(request: any NetworkRequest) async throws -> CastResponse {
		return try await networkClient.execute(request)
	}
}
