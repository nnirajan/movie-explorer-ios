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
	private let favouriteRepository: FavouriteRepository
	
	var movie: Movie?
	var cast: [Cast] = []
	var isFavourite: Bool = false
	
	// MARK: - init
	init(
		movieID: Int,
		movieRepository: MovieRepository,
		favouriteRepository: FavouriteRepository
	) {
		self.movieID = movieID
		self.movieRepository = movieRepository
		self.favouriteRepository = favouriteRepository
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
		Task {
			do {
				let request = MovieRequest.movieDetail(id: movieID)
				
				async let detailTask = movieRepository.getMovieDetail(request: request)
				async let favouriteTask = favouriteRepository.isFavourite(movieId: movieID)
				
				let (movie, isFavourite) = try await (detailTask, favouriteTask)
				self.movie = movie
				self.isFavourite = isFavourite
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
	
	@MainActor
	func toggleFavourite() {
		guard let movie else { return }
		
		Task {
			do {
				if isFavourite {
					print("🔄 Toggling OFF favourite for: \(movie.title)")
					try await favouriteRepository.removeFromFavourite(movieId: movie.id)
					isFavourite = false
				} else {
					print("🔄 Toggling ON favourite for: \(movie.title)")
					try await favouriteRepository.addToFavourite(movie)
					isFavourite = true
				}
				
				// Post notification AFTER successful operation
				NotificationCenter.default.post(name: .favourite, object: nil)
				
			} catch {
				print("❌ Failed to toggle favourite: \(error)")
			}
		}
	}
}
