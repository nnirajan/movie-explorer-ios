//
//  SchemaV2.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/07/2026.
//
//  Current schema (app version 2.x).
//  When adding a new schema version (V3), create SchemaV3.swift and add a
//  migration stage in AppMigrationPlan — do NOT modify this file.
//
//  Changes introduced in V2:
//  - MovieEntity: unique key is now compositeKey = "\(movieId)_\(category)"
//    allowing the same TMDB movie to be cached in multiple categories.

import Foundation
import SwiftData

enum SchemaV2: VersionedSchema {
	static var versionIdentifier = Schema.Version(2, 0, 0)

	static var models: [any PersistentModel.Type] {
		[MovieEntity.self, GenreEntity.self, FavouriteMovieEntity.self]
	}
}
