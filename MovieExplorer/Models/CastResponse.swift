//
//  CastResponse.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

// MARK: - CastResponse
struct CastResponse: Codable {
	var id: Int
	var cast: [Cast]
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(Int.self, forKey: .id)
		self.cast = try container.decode([Cast].self, forKey: .cast)
	}
	
}

// MARK: - Cast
struct Cast: Codable {
	var id: Int
	var name, originalName: String
	var profilePath: String?
	var character: String?

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case originalName = "original_name"
		case profilePath = "profile_path"
		case character
	}
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(Int.self, forKey: .id)
		self.name = try container.decode(String.self, forKey: .name)
		self.originalName = try container.decode(String.self, forKey: .originalName)
		self.profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath)
		self.character = try container.decodeIfPresent(String.self, forKey: .character)
	}
}
