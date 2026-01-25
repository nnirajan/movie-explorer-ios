//
//  GenreReponse.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

// MARK: - GenreReponse
struct GenreReponse: Codable {
	let genres: [Genre]

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.genres = try container.decode([Genre].self, forKey: .genres)
	}
}

extension GenreReponse {
	init(genres: [Genre]) {
		self.genres = genres
	}
}

// MARK: - Genre
struct Genre: Codable {
	let id: Int
	let name: String
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(Int.self, forKey: .id)
		self.name = try container.decode(String.self, forKey: .name)
	}
}

extension Genre {
	init(id: Int, name: String) {
		self.id = id
		self.name = name
	}
}
