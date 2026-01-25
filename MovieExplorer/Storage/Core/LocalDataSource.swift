//
//  LocalDataSource.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation
import SwiftData

// MARK: - LocalDataSource
/// Generic protocol for local storage CRUD operations
protocol LocalDataSource {
	associatedtype Entity: PersistentModel
	
	/// Fetches all entities from storage
	/// - Returns: Array of entities
	/// - Throws: StorageError if fetch operation fails
	func fetchAll() async throws -> [Entity]
	
	/// Fetches a single entity by its identifier
	/// - Parameter id: Unique identifier for the entity
	/// - Returns: Entity if found
	/// - Throws: StorageError if fetch fails or entity not found
	func fetchById<ID: Hashable>(_ id: ID) async throws -> Entity
	
	/// Fetches entities matching a predicate
	/// - Parameter predicate: Predicate to filter entities
	/// - Returns: Array of matching entities
	/// - Throws: StorageError if fetch operation fails
	func fetch(where predicate: Predicate<Entity>) async throws -> [Entity]
	
	/// Saves a single entity to storage
	/// - Parameter entity: Entity to save
	/// - Throws: StorageError if save operation fails
	func save(_ entity: Entity) async throws
	
	/// Saves an array of entities to storage
	/// - Parameter entities: Entities to save
	/// - Throws: StorageError if save operation fails
	func save(_ entities: [Entity]) async throws
	
	/// Updates an existing entity
	/// - Parameter entity: Entity to update (must already exist in context)
	/// - Throws: StorageError if update operation fails
	func update(_ entity: Entity) async throws
	
	/// Deletes a single entity from storage
	/// - Parameter entity: Entity to delete
	/// - Throws: StorageError if delete operation fails
	func delete(_ entity: Entity) async throws
	
	/// Deletes entities matching a predicate
	/// - Parameter predicate: Predicate to filter entities for deletion
	/// - Throws: StorageError if delete operation fails
	func delete(where predicate: Predicate<Entity>) async throws
	
	/// Deletes all entities from storage
	/// - Throws: StorageError if delete operation fails
	func deleteAll() async throws
	
	/// Checks if an entity exists by identifier
	/// - Parameter id: Unique identifier to check
	/// - Returns: True if entity exists, false otherwise
	func exists<ID: Hashable>(_ id: ID) async -> Bool
	
	/// Returns the count of all entities
	/// - Returns: Total number of entities in storage
	/// - Throws: StorageError if count operation fails
	func count() async throws -> Int
	
	/// Returns the count of entities matching a predicate
	/// - Parameter predicate: Predicate to filter entities
	/// - Returns: Number of matching entities
	/// - Throws: StorageError if count operation fails
	func count(where predicate: Predicate<Entity>) async throws -> Int
}

// MARK: - SwiftDataLocalDataSource
/// Generic SwiftData implementation of LocalDataSource
/// Follows Open/Closed Principle - open for extension via generics
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
		let entityName = String(describing: Entity.self)
		print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
		print("📦 [Storage] Fetching all \(entityName)...")
		
		let context = modelContainer.mainContext
		let descriptor = FetchDescriptor<Entity>()
		
		do {
			let results = try context.fetch(descriptor)
			print("✅ [Storage] Fetched \(results.count) \(entityName)(s)")
			return results
		} catch {
			print("❌ [Storage] Fetch failed for \(entityName): \(error.localizedDescription)")
			throw StorageError.fetchFailed(reason: error.localizedDescription)
		}
	}
	
	@MainActor
	func fetchById<ID: Hashable>(_ id: ID) async throws -> Entity {
		let entityName = String(describing: Entity.self)
		print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
		print("📦 [Storage] Fetching \(entityName) with ID: \(id)...")
		
		let context = modelContainer.mainContext
		
		do {
			// Attempt to find entity using model identifier
			if let persistentIdentifier = id as? PersistentIdentifier {
				if let entity = context.model(for: persistentIdentifier) as? Entity {
					print("✅ [Storage] Found \(entityName) with ID: \(id)")
					return entity
				}
			}
			
			print("❌ [Storage] \(entityName) not found with ID: \(id)")
			throw StorageError.entityNotFound
		} catch {
			if error is StorageError {
				throw error
			}
			print("❌ [Storage] Fetch by ID failed for \(entityName): \(error.localizedDescription)")
			throw StorageError.fetchFailed(reason: error.localizedDescription)
		}
	}
	
	@MainActor
	func fetch(where predicate: Predicate<Entity>) async throws -> [Entity] {
		let entityName = String(describing: Entity.self)
	
		print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
		print("📦 [Storage] Fetching \(entityName) with predicate...")
		
		let context = modelContainer.mainContext
		var descriptor = FetchDescriptor<Entity>(predicate: predicate)
		
		do {
			let results = try context.fetch(descriptor)
			print("✅ [Storage] Fetched \(results.count) \(entityName)(s) matching predicate")
			return results
		} catch {
			print("❌ [Storage] Predicate fetch failed for \(entityName): \(error.localizedDescription)")
			throw StorageError.fetchFailed(reason: error.localizedDescription)
		}
	}
	
	// MARK: - Create Operations
	
	@MainActor
	func save(_ entity: Entity) async throws {
		let entityName = String(describing: Entity.self)
		print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
		print("💾 [Storage] Saving \(entityName)...")
		
		let context = modelContainer.mainContext
		
		do {
			context.insert(entity)
			try context.save()
			print("✅ [Storage] Saved 1 \(entityName)")
		} catch {
			print("❌ [Storage] Save failed for \(entityName): \(error.localizedDescription)")
			throw StorageError.saveFailed(reason: error.localizedDescription)
		}
	}
	
	@MainActor
	func save(_ entities: [Entity]) async throws {
		let entityName = String(describing: Entity.self)
		print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
		print("💾 [Storage] Saving \(entities.count) \(entityName)(s)...")
		
		let context = modelContainer.mainContext
		
		do {
			entities.forEach { context.insert($0) }
			try context.save()
			print("✅ [Storage] Saved \(entities.count) \(entityName)(s)")
		} catch {
			print("❌ [Storage] Batch save failed for \(entityName): \(error.localizedDescription)")
			throw StorageError.saveFailed(reason: error.localizedDescription)
		}
	}
	
	// MARK: - Update Operations
	
	@MainActor
	func update(_ entity: Entity) async throws {
		let entityName = String(describing: Entity.self)
		print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
		print("🔄 [Storage] Updating \(entityName)...")
		
		let context = modelContainer.mainContext
		
		do {
			try context.save()
			print("✅ [Storage] Updated \(entityName)")
		} catch {
			print("❌ [Storage] Update failed for \(entityName): \(error.localizedDescription)")
			throw StorageError.saveFailed(reason: "Update failed: \(error.localizedDescription)")
		}
	}
	
	// MARK: - Delete Operations
	
	@MainActor
	func delete(_ entity: Entity) async throws {
		let entityName = String(describing: Entity.self)
		print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
		print("🗑️ [Storage] Deleting \(entityName)...")
		
		let context = modelContainer.mainContext
		
		do {
			context.delete(entity)
			try context.save()
			print("✅ [Storage] Deleted 1 \(entityName)")
		} catch {
			print("❌ [Storage] Delete failed for \(entityName): \(error.localizedDescription)")
			throw StorageError.deleteFailed(reason: error.localizedDescription)
		}
	}
	
	@MainActor
	func delete(where predicate: Predicate<Entity>) async throws {
		let entityName = String(describing: Entity.self)
		print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
		print("🗑️ [Storage] Deleting \(entityName)(s) matching predicate...")
		
		let context = modelContainer.mainContext
		
		do {
			let descriptor = FetchDescriptor<Entity>(predicate: predicate)
			let entities = try context.fetch(descriptor)
			
			entities.forEach { context.delete($0) }
			try context.save()
			print("✅ [Storage] Deleted \(entities.count) \(entityName)(s)")
		} catch {
			print("❌ [Storage] Predicate delete failed for \(entityName): \(error.localizedDescription)")
			throw StorageError.deleteFailed(reason: error.localizedDescription)
		}
	}
	
	@MainActor
	func deleteAll() async throws {
		let entityName = String(describing: Entity.self)
		print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
		print("🗑️ [Storage] Deleting ALL \(entityName)(s)...")
		
		let context = modelContainer.mainContext
		
		do {
			let descriptor = FetchDescriptor<Entity>()
			let entities = try context.fetch(descriptor)
			
			entities.forEach { context.delete($0) }
			try context.save()
			print("✅ [Storage] Deleted ALL \(entities.count) \(entityName)(s)")
		} catch {
			print("❌ [Storage] Delete all failed for \(entityName): \(error.localizedDescription)")
			throw StorageError.deleteFailed(reason: error.localizedDescription)
		}
	}
	
	// MARK: - Utility Operations
	
	@MainActor
	func exists<ID: Hashable>(_ id: ID) async -> Bool {
		do {
			_ = try await fetchById(id)
			return true
		} catch {
			return false
		}
	}
	
	@MainActor
	func count() async throws -> Int {
		let entityName = String(describing: Entity.self)
		print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
		print("🔢 [Storage] Counting \(entityName)(s)...")
		
		let context = modelContainer.mainContext
		let descriptor = FetchDescriptor<Entity>()
		
		do {
			let count = try context.fetchCount(descriptor)
			print("✅ [Storage] Count: \(count) \(entityName)(s)")
			return count
		} catch {
			print("❌ [Storage] Count failed for \(entityName): \(error.localizedDescription)")
			throw StorageError.fetchFailed(reason: "Count failed: \(error.localizedDescription)")
		}
	}
	
	@MainActor
	func count(where predicate: Predicate<Entity>) async throws -> Int {
		let entityName = String(describing: Entity.self)
		
		print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
		print("🔢 [Storage] Counting \(entityName)(s) with predicate...")
		
		let context = modelContainer.mainContext
		let descriptor = FetchDescriptor<Entity>(predicate: predicate)
		
		do {
			let count = try context.fetchCount(descriptor)
			print("✅ [Storage] Count: \(count) \(entityName)(s) matching predicate")
			return count
		} catch {
			print("❌ [Storage] Predicate count failed for \(entityName): \(error.localizedDescription)")
			throw StorageError.fetchFailed(reason: "Count failed: \(error.localizedDescription)")
		}
	}
}

// MARK: - Advanced Query Support
extension SwiftDataLocalDataSource {
	
	/// Fetches entities with sorting
	/// - Parameters:
	///   - sortBy: Sort descriptors for ordering results
	///   - predicate: Optional predicate to filter results
	/// - Returns: Sorted array of entities
	@MainActor
	func fetch(
		sortBy: [SortDescriptor<Entity>],
		where predicate: Predicate<Entity>? = nil
	) async throws -> [Entity] {
		let context = modelContainer.mainContext
		var descriptor = FetchDescriptor<Entity>(predicate: predicate, sortBy: sortBy)
		
		do {
			return try context.fetch(descriptor)
		} catch {
			throw StorageError.fetchFailed(reason: error.localizedDescription)
		}
	}
	
	/// Fetches entities with pagination
	/// - Parameters:
	///   - limit: Maximum number of entities to fetch
	///   - offset: Number of entities to skip
	///   - predicate: Optional predicate to filter results
	/// - Returns: Paginated array of entities
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
	
	/// Batch update operation
	/// - Parameter updateBlock: Closure to perform updates on each entity
	/// - Throws: StorageError if batch update fails
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
