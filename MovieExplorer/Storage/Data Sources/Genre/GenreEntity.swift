//
//  GenreEntity.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation
import SwiftData

@Model
final class GenreEntity {
	// MARK: - Properties
	@Attribute(.unique) var id: Int
	var name: String
	var createdAt: Date
	
	// MARK: - Initialization
	init(
		id: Int,
		name: String,
		createdAt: Date = Date()
	) {
		self.id = id
		self.name = name
		self.createdAt = createdAt
	}
}
