//
//  FavouriteEntityMapper.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

struct FavouriteEntityMapper {
	
	// MARK: - Domain to Entity
	func toEntity(from movie: Movie) -> FavouriteMovieEntity {
		print("🔄 [Mapper] Converting Movie to Entity: \(movie.title) (ID: \(movie.id))")
		
		return FavouriteMovieEntity(
			id: movie.id,
			title: movie.title,
			overview: movie.overview,
			popularity: movie.popularity,
			posterPath: movie.posterPath,
			releaseDate: movie.releaseDate,
			voteAverage: movie.voteAverage,
			genreIDS: movie.genreIDS ?? [],
			backdropPath: movie.backdropPath,
			runtime: movie.runtime,
			createdAt: Date()
		)
	}
	
	// MARK: - Entity to Domain
	func toDomain(from entity: FavouriteMovieEntity) -> Movie {
		print("🔄 [Mapper] Converting Entity to Movie: \(entity.title) (ID: \(entity.id))")
		
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
