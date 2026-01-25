//
//  GenreEntity.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation
import SwiftData

@Model
final class MovieEntity {
	// MARK: - Properties
	@Attribute(.unique) var id: Int
	var title: String
	var overview: String
	var popularity: Double
	var posterPath: String?
	var releaseDate: String
	var voteAverage: Double
	var genreIDS: [Int]?
	var backdropPath: String?
	var runtime: Int?
	var category: String // Store category as String for SwiftData compatibility
	var createdAt: Date
	
	// MARK: - Computed Property
	var movieCategory: MovieCategory? {
		MovieCategory(rawValue: category)
	}
	
	// MARK: - Initialization
	init(
		id: Int,
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
		self.id = id
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
