//
//  HomeViewModel.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import Foundation

@Observable
class HomeViewModel: BaseViewModel {
	// MARK: - properties
	private let movieRepository: MovieRepository
	
	var genres: [Genre] = []
	var nowPlayingMovies: [Movie] = []
	var popularResponse: MovieResponse?
	
	var isFetchingMore: Bool = false
	
	var hasMorePopularMovies: Bool {
		guard let response = popularResponse else { return false }
		return response.page < response.totalPages
	}
	
	// MARK: - init
	init(movieRepository: MovieRepository) {
		self.movieRepository = movieRepository
		super.init()
	}
	
	// MARK: - getInitialData
	@MainActor
	func getInitialData() {
		setLoading()
		
		Task {
			do {
				// Call all 3 concurrently
				async let genresTask = getGenres()
				async let nowPlayingTask = getNowPlayingMovies()
				async let popularTask = getInitialPopularMovies()
				
				// Wait for all responses
				let (genreResponse, nowPlayingResponse, popularResponse) = try await (
					genresTask,
					nowPlayingTask,
					popularTask
				)
				
				self.genres = genreResponse.genres
				self.nowPlayingMovies = nowPlayingResponse.results
				self.popularResponse = popularResponse
				
				setContent()
			} catch {
				setError()
			}
		}
	}
	
	// MARK: - getGenres
	@MainActor
	func getGenres() async throws -> GenreReponse {
		try await movieRepository.getGenres(request: MovieRequest.genre)
	}
	
	// MARK: - getNowPlayingMovies
	@MainActor
	func getNowPlayingMovies() async throws -> MovieResponse {
		try await movieRepository.getNowPlayingMovies(request: MovieRequest.nowPlaying)
	}
	
	// MARK: - getInitialPopularMovies
	@MainActor
	func getInitialPopularMovies() async throws -> MovieResponse {
		let params: Parameters = [
			"page": 1
		]
		let request = MovieRequest.popular(params)
		return try await movieRepository.getPopularMovies(request: request)
	}
	
	// MARK: - getMorePopularMovies
	@MainActor
	func getMorePopularMovies() async {
		guard !isFetchingMore, hasMorePopularMovies else { return }
		
		isFetchingMore = true
		defer { isFetchingMore = false }
		
		let nextPage = (popularResponse?.page ?? 1) + 1
		
		let params: Parameters = [
			"page": nextPage
		]
		let request = MovieRequest.popular(params)
		
		do {
			let response = try await movieRepository.getPopularMovies(request: request)
			
			popularResponse?.results.append(contentsOf: response.results)
			popularResponse?.page = response.page
			popularResponse?.totalPages = response.totalPages
		} catch {
			print("Pagination failed:", error)
		}
	}
}
