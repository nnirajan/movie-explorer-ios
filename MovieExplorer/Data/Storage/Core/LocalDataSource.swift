//
//  LocalDataSource.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation
import SwiftData

// MARK: - LocalDataSource
protocol LocalDataSource {
	associatedtype Entity: PersistentModel

	func fetchAll() async throws -> [Entity]
	func fetchById<ID: Hashable>(_ id: ID) async throws -> Entity
	func fetch(where predicate: Predicate<Entity>) async throws -> [Entity]
	func save(_ entity: Entity) async throws
	func save(_ entities: [Entity]) async throws
	func update(_ entity: Entity) async throws
	func delete(_ entity: Entity) async throws
	func delete(where predicate: Predicate<Entity>) async throws
	func deleteAll() async throws
	func exists<ID: Hashable>(_ id: ID) async -> Bool
	func count() async throws -> Int
	func count(where predicate: Predicate<Entity>) async throws -> Int
}

// MARK: - SwiftDataLocalDataSource
final class SwiftDataLocalDataSource<Entity: PersistentModel>: LocalDataSource {
	// MARK: - Properties
	private let modelContainer: ModelContainer

	// MARK: - Initialization
	init(modelContainer: ModelContainer) {
		self.modelContainer = modelContainer
	}

	// MARK: - Read Operations

	@MainActor
	func fetchAll() async throws -> [Entity] {
		let context = modelContainer.mainContext
		let descriptor = FetchDescriptor<Entity>()
		do {
			return try context.fetch(descriptor)
		} catch {
			throw StorageError.fetchFailed(reason: error.localizedDescription)
		}
	}

	@MainActor
	func fetchById<ID: Hashable>(_ id: ID) async throws -> Entity {
		let context = modelContainer.mainContext
		do {
			if let persistentIdentifier = id as? PersistentIdentifier,
			   let entity = context.model(for: persistentIdentifier) as? Entity {
				return entity
			}
			throw StorageError.entityNotFound
		} catch {
			if error is StorageError { throw error }
			throw StorageError.fetchFailed(reason: error.localizedDescription)
		}
	}

	@MainActor
	func fetch(where predicate: Predicate<Entity>) async throws -> [Entity] {
		let context = modelContainer.mainContext
		let descriptor = FetchDescriptor<Entity>(predicate: predicate)
		do {
			return try context.fetch(descriptor)
		} catch {
			throw StorageError.fetchFailed(reason: error.localizedDescription)
		}
	}

	// MARK: - Create Operations

	@MainActor
	func save(_ entity: Entity) async throws {
		let context = modelContainer.mainContext
		do {
			context.insert(entity)
			try context.save()
		} catch {
			throw StorageError.saveFailed(reason: error.localizedDescription)
		}
	}

	@MainActor
	func save(_ entities: [Entity]) async throws {
		let context = modelContainer.mainContext
		do {
			entities.forEach { context.insert($0) }
			try context.save()
		} catch {
			throw StorageError.saveFailed(reason: error.localizedDescription)
		}
	}

	// MARK: - Update Operations

	@MainActor
	func update(_ entity: Entity) async throws {
		let context = modelContainer.mainContext
		do {
			try context.save()
		} catch {
			throw StorageError.saveFailed(reason: "Update failed: \(error.localizedDescription)")
		}
	}

	// MARK: - Delete Operations

	@MainActor
	func delete(_ entity: Entity) async throws {
		let context = modelContainer.mainContext
		do {
			context.delete(entity)
			try context.save()
		} catch {
			throw StorageError.deleteFailed(reason: error.localizedDescription)
		}
	}

	@MainActor
	func delete(where predicate: Predicate<Entity>) async throws {
		let context = modelContainer.mainContext
		do {
			let descriptor = FetchDescriptor<Entity>(predicate: predicate)
			let entities = try context.fetch(descriptor)
			entities.forEach { context.delete($0) }
			try context.save()
		} catch {
			throw StorageError.deleteFailed(reason: error.localizedDescription)
		}
	}

	@MainActor
	func deleteAll() async throws {
		let context = modelContainer.mainContext
		do {
			let descriptor = FetchDescriptor<Entity>()
			let entities = try context.fetch(descriptor)
			entities.forEach { context.delete($0) }
			try context.save()
		} catch {
			throw StorageError.deleteFailed(reason: error.localizedDescription)
		}
	}

	// MARK: - Utility Operations

	@MainActor
	func exists<ID: Hashable>(_ id: ID) async -> Bool {
		(try? await fetchById(id)) != nil
	}

	@MainActor
	func count() async throws -> Int {
		let context = modelContainer.mainContext
		let descriptor = FetchDescriptor<Entity>()
		do {
			return try context.fetchCount(descriptor)
		} catch {
			throw StorageError.fetchFailed(reason: "Count failed: \(error.localizedDescription)")
		}
	}

	@MainActor
	func count(where predicate: Predicate<Entity>) async throws -> Int {
		let context = modelContainer.mainContext
		let descriptor = FetchDescriptor<Entity>(predicate: predicate)
		do {
			return try context.fetchCount(descriptor)
		} catch {
			throw StorageError.fetchFailed(reason: "Count failed: \(error.localizedDescription)")
		}
	}
}

// MARK: - Advanced Query Support
extension SwiftDataLocalDataSource {
	@MainActor
	func fetch(
		sortBy: [SortDescriptor<Entity>],
		where predicate: Predicate<Entity>? = nil
	) async throws -> [Entity] {
		let context = modelContainer.mainContext
		let descriptor = FetchDescriptor<Entity>(predicate: predicate, sortBy: sortBy)
		do {
			return try context.fetch(descriptor)
		} catch {
			throw StorageError.fetchFailed(reason: error.localizedDescription)
		}
	}

	@MainActor
	func fetch(
		limit: Int,
		offset: Int = 0,
		where predicate: Predicate<Entity>? = nil
	) async throws -> [Entity] {
		let context = modelContainer.mainContext
		var descriptor = FetchDescriptor<Entity>(predicate: predicate)
		descriptor.fetchLimit = limit
		descriptor.fetchOffset = offset
		do {
			return try context.fetch(descriptor)
		} catch {
			throw StorageError.fetchFailed(reason: error.localizedDescription)
		}
	}

	@MainActor
	func batchUpdate(
		where predicate: Predicate<Entity>? = nil,
		updateBlock: (Entity) -> Void
	) async throws {
		let context = modelContainer.mainContext
		do {
			let descriptor = FetchDescriptor<Entity>(predicate: predicate)
			let entities = try context.fetch(descriptor)
			entities.forEach(updateBlock)
			try context.save()
		} catch {
			throw StorageError.saveFailed(reason: "Batch update failed: \(error.localizedDescription)")
		}
	}
}
