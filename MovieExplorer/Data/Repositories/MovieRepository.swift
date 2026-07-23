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

final class MovieRepositoryImpl: MovieRepository {
	// MARK: - Properties
	private let networkClient: NetworkClientProtocol
	private let store: MovieStore

	// MARK: - Initialization
	init(
		networkClient: NetworkClientProtocol,
		store: MovieStore
	) {
		self.networkClient = networkClient
		self.store = store
	}
	
	// MARK: - getNowPlayingMovies
	func getNowPlayingMovies(request: NetworkRequest) async throws -> MovieResponse {
		do {
			let response: MovieResponse = try await networkClient.execute(request)
			try? await store.replaceMovies(response.results, category: .nowPlaying)
			return response
		} catch {
			if let cachedMovies = try? await store.fetchMovies(byCategory: .nowPlaying),
			   !cachedMovies.isEmpty {
				print("📦 Network failed, using cached now playing movies")
				return MovieResponse(
					results: cachedMovies,
					page: 1,
					totalPages: 1,
					totalResults: cachedMovies.count
				)
			}
			
			throw error
		}
	}
	
	// MARK: - getPopularMovies
	func getPopularMovies(request: NetworkRequest) async throws -> MovieResponse {
		do {
			let response: MovieResponse = try await networkClient.execute(request)
			try? await store.saveMovies(response.results, category: .popular)
			return response
		} catch {
			// Network failed, try cache for popular category
			if let cachedMovies = try? await store.fetchMovies(byCategory: .popular),
			   !cachedMovies.isEmpty {
				print("📦 Network failed, using cached popular movies")
				
				return MovieResponse(
					results: cachedMovies,
					page: 1,
					totalPages: 1,
					totalResults: cachedMovies.count
				)
			}
			
			throw error
		}
	}
	
	// MARK: - getMovieDetail
	func getMovieDetail(request: NetworkRequest) async throws -> Movie {
		do {
			let movie: Movie = try await networkClient.execute(request)
			
			try? await store.saveMovie(movie, category: .detail)
			print("💾 [Repository] Cached movie detail for ID: \(movie.id)")
			
			return movie
		} catch {
//			if let cachedMovie = try? await store.fetchMovie(byId: movie.id) {
//				print("📦 Network failed, using cached movie detail")
//				return cachedMovie
//			}
			
			throw error
		}
	}
	
	func getCredits(request: NetworkRequest) async throws -> CastResponse {
		return try await networkClient.execute(request)
	}
	
	func clearCache(category: MovieCategory) async throws {
		try await store.deleteMovies(byCategory: category)
		print("🗑️ [Repository] Cleared cache for category: \(category.rawValue)")
	}
	
	func clearAllCache() async throws {
		try await store.clearMovies()
		print("🗑️ [Repository] Cleared all movie caches")
	}
}
