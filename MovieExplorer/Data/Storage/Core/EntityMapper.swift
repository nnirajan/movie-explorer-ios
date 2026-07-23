//
//  EntityMapper.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

// MARK: - EntityMapper
/// Protocol for bidirectional mapping between domain models and storage entities
/// Follows Single Responsibility Principle - only handles conversion logic
protocol EntityMapper {
	associatedtype DomainModel
	associatedtype EntityModel
	
	/// Converts domain model to storage entity
	/// - Parameter domain: The domain model to convert
	/// - Returns: Converted storage entity
	/// - Throws: StorageError.mappingFailed if conversion fails
	func toEntity(_ domain: DomainModel) throws -> EntityModel
	
	/// Converts storage entity to domain model
	/// - Parameter entity: The storage entity to convert
	/// - Returns: Converted domain model
	/// - Throws: StorageError.mappingFailed if conversion fails
	func toDomain(_ entity: EntityModel) throws -> DomainModel
	
	/// Converts array of domain models to storage entities
	/// - Parameter domains: Array of domain models
	/// - Returns: Array of converted storage entities
	/// - Throws: StorageError.mappingFailed if any conversion fails
	func toEntities(_ domains: [DomainModel]) throws -> [EntityModel]
	
	/// Converts array of storage entities to domain models
	/// - Parameter entities: Array of storage entities
	/// - Returns: Array of converted domain models
	/// - Throws: StorageError.mappingFailed if any conversion fails
	func toDomains(_ entities: [EntityModel]) throws -> [DomainModel]
}

// MARK: - Default Implementations
extension EntityMapper {
	func toEntities(_ domains: [DomainModel]) throws -> [EntityModel] {
		try domains.map { try toEntity($0) }
	}
	
	func toDomains(_ entities: [EntityModel]) throws -> [DomainModel] {
		try entities.map { try toDomain($0) }
	}
}
