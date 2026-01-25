
//
//  MovieNetworkRepository.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

final class MovieNetworkRepository {
	// MARK: - Properties
	private let networkClient: NetworkClientProtocol
	
	// MARK: - Initialization
	init(networkClient: NetworkClientProtocol) {
		self.networkClient = networkClient
	}
	
	func getNowPlayingMovies(request: NetworkRequest) async throws -> MovieResponse {
		let response: MovieResponse = try await networkClient.execute(request)
		return response
	}
	
	func getPopularMovies(request: NetworkRequest) async throws -> MovieResponse {
		let response: MovieResponse = try await networkClient.execute(request)
		return response
	}
	
	func getMovieDetail(request: any NetworkRequest) async throws -> Movie {
		let response: Movie = try await networkClient.execute(request)
		return response
	}
	
	func getCredits(request: any NetworkRequest) async throws -> CastResponse {
		let response: CastResponse = try await networkClient.execute(request)
		return response
	}
}
