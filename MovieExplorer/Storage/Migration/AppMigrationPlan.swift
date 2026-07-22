//
//  AppMigrationPlan.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/07/2026.
//
//  How to add a future migration:
//  1. Create SchemaVN.swift with the new VersionedSchema.
//  2. Add a new MigrationStage below (lightweight or custom).
//  3. Append SchemaVN to `schemas` and the new stage to `stages`.
//
//  Lightweight  — use for: adding optional properties, renaming properties/entities.
//  Custom       — use for: restructuring data, changing unique keys, splitting/merging entities.

import Foundation
import SwiftData

enum AppMigrationPlan: SchemaMigrationPlan {

	static var schemas: [any VersionedSchema.Type] {
		[SchemaV1.self, SchemaV2.self]
	}

	static var stages: [MigrationStage] {
		[migrateV1toV2]
	}

	// Update this to the latest schema when adding a new version.
	static var currentModels: [any PersistentModel.Type] { SchemaV2.models }


	// MARK: - V1 → V2
	// MovieEntity's unique key changed from a single `id` to a composite
	// `compositeKey` ("<movieId>_<category>"). The old `id` field cannot be
	// mapped to `compositeKey` without knowing each record's intended category,
	// so all cached movies are wiped in willMigrate (before the schema change).
	// They are re-fetched from the network on the next launch.
	// Favourites (FavouriteMovieEntity) and Genres are unaffected and preserved.
	static let migrateV1toV2 = MigrationStage.custom(
		fromVersion: SchemaV1.self,
		toVersion: SchemaV2.self,
		willMigrate: { context in
			let movies = try context.fetch(FetchDescriptor<SchemaV1.MovieEntity>())
			print("[AppMigrationPlan] v1 -> v2: wiping \(movies.count) cached movies")
			movies.forEach { context.delete($0) }
			try context.save()
			print("[AppMigrationPlan] v1 -> v2: done")
		},
		didMigrate: nil
	)
}
