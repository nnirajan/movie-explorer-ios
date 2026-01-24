//
//  DetailViewModel.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import Foundation

@Observable
class DetailViewModel: BaseViewModel {
	// MARK: - properties
	private let movieID: Int
	private let movieRepository: MovieRepository

	var movie: Movie?
	var cast: [Cast] = []
	
	// MARK: - init
	init(
		movieID: Int,
		movieRepository: MovieRepository
	) {
		self.movieID = movieID
		self.movieRepository = movieRepository
		super.init()
	}
	
	// MARK: - getInitialData
	@MainActor
	func getInitialData() {
		setLoading()
		getMovieDetail()
		getCredits()
	}
	
	// MARK: - getMovieDetail
	@MainActor
	func getMovieDetail() {
		let request = MovieRequest.movieDetail(id: movieID)
		
		Task {
			do {
				self.movie = try await movieRepository.getMovieDetail(request: request)
				setContent()
			} catch {
				setError()
			}
		}
	}
	
	// MARK: - getCredits
	@MainActor
	func getCredits() {
		let request = MovieRequest.credits(id: movieID)
		
		Task {
			do {
				let castResponse = try await movieRepository.getCredits(request: request)
				cast = castResponse.cast
			} catch {
				
			}
		}
	}
}
