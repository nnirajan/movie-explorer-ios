//
//  MovieResponse.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import Foundation

struct MovieResponse: Codable {
	var results: [Movie]
	var page: Int
	var totalPages, totalResults: Int
	
	enum CodingKeys: String, CodingKey {
		case results
		case page
		case totalPages = "total_pages"
		case totalResults = "total_results"
	}
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.results = try container.decode([Movie].self, forKey: .results)
		self.page = try container.decode(Int.self, forKey: .page)
		self.totalPages = try container.decode(Int.self, forKey: .totalPages)
		self.totalResults = try container.decode(Int.self, forKey: .totalResults)
	}
}

struct Movie: Codable {
	let id: Int
	let title, overview: String
	let popularity: Double
	let posterPath, releaseDate: String
	let voteAverage: Double
	let genreIDS: [Int]
	
	// MARK: - Computed properties
	var formattedReleaseDate: String {
		guard let date = releaseDate.toDate(format: SupportedDateFormat.yyyyMMdd) else {
			return releaseDate
		}
		return date.toString(format: .MMMdyyyy)
	}
	
	var formattedRating: String {
		voteAverage.formatted(.number.precision(.fractionLength(1)))
	}
	
	enum CodingKeys: String, CodingKey {
		case id
		case title
		case overview
		case popularity
		case posterPath = "poster_path"
		case releaseDate = "release_date"
		case voteAverage = "vote_average"
		case genreIDS = "genre_ids"
	}
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.id = try container.decode(Int.self, forKey: .id)
		self.title = try container.decode(String.self, forKey: .title)
		self.overview = try container.decode(String.self, forKey: .overview)
		self.popularity = try container.decode(Double.self, forKey: .popularity)
		self.posterPath = try container.decode(String.self, forKey: .posterPath)
		self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
		self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
		self.genreIDS = try container.decode([Int].self, forKey: .genreIDS)
	}
}
