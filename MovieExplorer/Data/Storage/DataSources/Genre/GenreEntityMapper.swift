//
//  GenreEntityMapper.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

struct GenreEntityMapper: EntityMapper {
	typealias DomainModel = Genre
	typealias EntityModel = GenreEntity
	
	// MARK: - EntityMapper Implementation
	func toEntity(_ domain: Genre) throws -> GenreEntity {
		return GenreEntity(
			id: domain.id,
			name: domain.name
		)
	}
	
	func toDomain(_ entity: GenreEntity) throws -> Genre {
		return Genre(
			id: entity.id,
			name: entity.name
		)
	}
}
