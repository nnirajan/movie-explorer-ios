//
//  DetailViewModel.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import Foundation

@Observable
final class DetailViewModel: BaseViewModel {
	// MARK: - Properties
	private let movieID: Int
	private let movieRepository: MovieRepository
	private let favouriteRepository: FavouriteRepository

	var movie: Movie?
	var cast: [Cast] = []
	var isFavourite: Bool = false
	var creditsLoadFailed: Bool = false

	// MARK: - Initialization
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
	// Both loads run concurrently via async let inside a single structured Task.
	@MainActor
	func getInitialData() {
		setLoading()
		Task {
			async let detail: Void = loadMovieDetail()
			async let credits: Void = loadCredits()
			_ = await (detail, credits)
		}
	}

	// MARK: - Private Loaders

	@MainActor
	private func loadMovieDetail() async {
		do {
			let request = MovieRequest.detail(id: movieID)
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

	@MainActor
	private func loadCredits() async {
		do {
			let request = MovieRequest.credits(id: movieID)
			let castResponse = try await movieRepository.getCredits(request: request)
			cast = castResponse.cast
		} catch {
			print("⚠️ [DetailViewModel] Failed to load credits: \(error)")
			creditsLoadFailed = true
		}
	}

	// MARK: - toggleFavourite
	@MainActor
	func toggleFavourite() {
		guard let movie else { return }

		Task {
			do {
				if isFavourite {
					try await favouriteRepository.removeFromFavourite(movieId: movie.id)
					isFavourite = false
				} else {
					try await favouriteRepository.addToFavourite(movie)
					isFavourite = true
				}
				NotificationCenter.default.post(name: .favourite, object: nil)
			} catch {
				print("❌ [DetailViewModel] Failed to toggle favourite: \(error)")
			}
		}
	}
}
