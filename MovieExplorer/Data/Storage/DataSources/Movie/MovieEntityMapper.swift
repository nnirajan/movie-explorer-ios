//
//  MovieEntityMapper.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

struct MovieEntityMapper: EntityMapper {
	typealias DomainModel = Movie
	typealias EntityModel = MovieEntity

	// MARK: - EntityMapper Implementation

	func toEntity(_ domain: Movie) throws -> MovieEntity {
		// Category is always required — use toEntity(_:category:) instead.
		throw StorageError.mappingFailed(reason: "MovieEntityMapper requires a category. Use toEntity(_:category:).")
	}

	func toEntity(_ domain: Movie, category: MovieCategory) throws -> MovieEntity {
		MovieEntity(
			movieId: domain.id,
			title: domain.title,
			overview: domain.overview,
			popularity: domain.popularity,
			posterPath: domain.posterPath,
			releaseDate: domain.releaseDate,
			voteAverage: domain.voteAverage,
			genreIDS: domain.genreIDS,
			backdropPath: domain.backdropPath,
			runtime: domain.runtime,
			category: category
		)
	}

	func toEntities(_ domains: [Movie], category: MovieCategory) throws -> [MovieEntity] {
		try domains.map { try toEntity($0, category: category) }
	}

	func toDomain(_ entity: MovieEntity) throws -> Movie {
		Movie(
			id: entity.movieId,
			title: entity.title,
			overview: entity.overview,
			popularity: entity.popularity,
			posterPath: entity.posterPath,
			releaseDate: entity.releaseDate,
			voteAverage: entity.voteAverage,
			genreIDS: entity.genreIDS,
			backdropPath: entity.backdropPath,
			runtime: entity.runtime
		)
	}
}
