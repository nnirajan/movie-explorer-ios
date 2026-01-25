//
//  StorageError.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

// MARK: - StorageError
/// Represents errors that can occur during local storage operations
enum StorageError: LocalizedError {
	case fetchFailed(reason: String)
	case saveFailed(reason: String)
	case deleteFailed(reason: String)
	case mappingFailed(reason: String)
	case contextUnavailable
	case entityNotFound
	
	var errorDescription: String? {
		switch self {
		case .fetchFailed(let reason):
			return "Failed to fetch data: \(reason)"
		case .saveFailed(let reason):
			return "Failed to save data: \(reason)"
		case .deleteFailed(let reason):
			return "Failed to delete data: \(reason)"
		case .mappingFailed(let reason):
			return "Failed to map entity: \(reason)"
		case .contextUnavailable:
			return "Storage context is unavailable"
		case .entityNotFound:
			return "Entity not found in storage"
		}
	}
}
