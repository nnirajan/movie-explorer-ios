//
//  FavouriteEntityMapper.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

struct FavouriteEntityMapper: EntityMapper {
	typealias DomainModel = Movie
	typealias EntityModel = FavouriteMovieEntity

	// MARK: - EntityMapper

	func toEntity(_ domain: Movie) throws -> FavouriteMovieEntity {
		FavouriteMovieEntity(
			id: domain.id,
			title: domain.title,
			overview: domain.overview,
			popularity: domain.popularity,
			posterPath: domain.posterPath,
			releaseDate: domain.releaseDate,
			voteAverage: domain.voteAverage,
			genreIDS: domain.genreIDS ?? [],
			backdropPath: domain.backdropPath,
			runtime: domain.runtime,
			createdAt: Date()
		)
	}

	func toDomain(_ entity: FavouriteMovieEntity) throws -> Movie {
		Movie(
			id: entity.id,
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
