//
//  SchemaV1.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/07/2026.
//
//  Frozen snapshot of the original schema (app version 1.x).
//  Do NOT modify — this is a historical record used for migration.
//
//  Changes from V1 → V2:
//  - MovieEntity: replaced @Attribute(.unique) id with a composite key
//    (compositeKey = "\(movieId)_\(category)") to allow the same TMDB movie
//    to exist in multiple categories (nowPlaying, popular, detail).

import Foundation
import SwiftData

enum SchemaV1: VersionedSchema {
	static var versionIdentifier = Schema.Version(1, 0, 0)

	static var models: [any PersistentModel.Type] {
		[SchemaV1.MovieEntity.self, GenreEntity.self, FavouriteMovieEntity.self]
	}

	@Model
	final class MovieEntity {
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
		var category: String
		var createdAt: Date

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
			category: String,
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
			self.category = category
			self.createdAt = createdAt
		}
	}
}
