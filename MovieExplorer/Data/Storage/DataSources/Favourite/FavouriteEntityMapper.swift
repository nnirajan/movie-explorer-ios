//
//  FavouriteEntityMapper.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

// MARK: - FavouriteEntityMapper
enum FavouriteEntityMapper {
	// MARK: - Mapping
	static func toEntity(_ domain: Movie) -> FavouriteMovieEntity {
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

	static func toDomain(_ entity: FavouriteMovieEntity) -> Movie {
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

	static func toEntities(_ domains: [Movie]) -> [FavouriteMovieEntity] {
		domains.map { toEntity($0) }
	}

	static func toDomains(_ entities: [FavouriteMovieEntity]) -> [Movie] {
		entities.map { toDomain($0) }
	}
}
