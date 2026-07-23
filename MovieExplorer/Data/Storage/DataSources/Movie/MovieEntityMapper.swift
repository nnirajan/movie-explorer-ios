//
//  MovieEntityMapper.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

// MARK: - MovieEntityMapper
enum MovieEntityMapper {
	// MARK: - Domain to Entity
	static func toEntity(_ domain: Movie, category: MovieCategory) -> MovieEntity {
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

	static func toEntities(_ domains: [Movie], category: MovieCategory) -> [MovieEntity] {
		domains.map { toEntity($0, category: category) }
	}

	// MARK: - Entity to Domain
	static func toDomain(_ entity: MovieEntity) -> Movie {
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

	static func toDomains(_ entities: [MovieEntity]) -> [Movie] {
		entities.map { toDomain($0) }
	}
}
