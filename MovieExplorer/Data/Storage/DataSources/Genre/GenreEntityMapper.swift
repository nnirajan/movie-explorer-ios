//
//  GenreEntityMapper.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

// MARK: - GenreEntityMapper
enum GenreEntityMapper {
	// MARK: - Mapping
	static func toEntity(_ domain: Genre) -> GenreEntity {
		GenreEntity(id: domain.id, name: domain.name)
	}

	static func toDomain(_ entity: GenreEntity) -> Genre {
		Genre(id: entity.id, name: entity.name)
	}

	static func toEntities(_ domains: [Genre]) -> [GenreEntity] {
		domains.map { toEntity($0) }
	}

	static func toDomains(_ entities: [GenreEntity]) -> [Genre] {
		entities.map { toDomain($0) }
	}
}
