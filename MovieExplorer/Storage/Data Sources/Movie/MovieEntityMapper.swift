//
//  GenreEntityMapper.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

struct MovieEntityMapper: EntityMapper {
	typealias DomainModel = Movie
	typealias EntityModel = MovieEntity
	
	// MARK: - EntityMapper Implementation
	
	/// Converts Movie to MovieEntity with category
	func toEntity(_ domain: Movie, category: MovieCategory) throws -> MovieEntity {
		return MovieEntity(
			id: domain.id,
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
	
	/// Converts array of Movies to MovieEntities with category
	func toEntities(_ domains: [Movie], category: MovieCategory) throws -> [MovieEntity] {
		try domains.map { try toEntity($0, category: category) }
	}
	
	func toEntity(_ domain: Movie) throws -> MovieEntity {
		// Default to detail category if not specified
		return try toEntity(domain, category: .nowPlaying)
	}
	
	func toDomain(_ entity: MovieEntity) throws -> Movie {
		return Movie(
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
