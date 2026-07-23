//
//  MovieEntity.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation
import SwiftData

@Model
final class MovieEntity {
	// MARK: - Properties

	/// Composite unique key: "<movieId>_<category>" — prevents constraint violations when the
	/// same TMDB movie ID appears in multiple categories (e.g. nowPlaying AND popular).
	@Attribute(.unique) var compositeKey: String
	var movieId: Int
	var title: String
	var overview: String
	var popularity: Double
	var posterPath: String?
	var releaseDate: String
	var voteAverage: Double
	var genreIDS: [Int]?
	var backdropPath: String?
	var runtime: Int?
	var category: String
	var createdAt: Date

	// MARK: - Computed Property
	var movieCategory: MovieCategory? {
		MovieCategory(rawValue: category)
	}

	// MARK: - Initialization
	init(
		movieId: Int,
		title: String,
		overview: String,
		popularity: Double,
		posterPath: String? = nil,
		releaseDate: String,
		voteAverage: Double,
		genreIDS: [Int]? = nil,
		backdropPath: String? = nil,
		runtime: Int? = nil,
		category: MovieCategory,
		createdAt: Date = Date()
	) {
		self.compositeKey = "\(movieId)_\(category.rawValue)"
		self.movieId = movieId
		self.title = title
		self.overview = overview
		self.popularity = popularity
		self.posterPath = posterPath
		self.releaseDate = releaseDate
		self.voteAverage = voteAverage
		self.genreIDS = genreIDS
		self.backdropPath = backdropPath
		self.runtime = runtime
		self.category = category.rawValue
		self.createdAt = createdAt
	}
}
