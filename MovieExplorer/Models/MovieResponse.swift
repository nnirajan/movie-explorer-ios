//
//  MovieResponse.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import Foundation

// MARK: - MovieResponse
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

extension MovieResponse {
	init(results: [Movie], page: Int, totalPages: Int, totalResults: Int) {
		self.results = results
		self.page = page
		self.totalPages = totalPages
		self.totalResults = totalResults
	}
}


// MARK: - Movie
struct Movie: Codable, Identifiable {
	var id: Int
	var title, overview: String
	var popularity: Double
	var posterPath: String?
	var releaseDate: String
	var voteAverage: Double
	var genreIDS: [Int]?
	var backdropPath: String?
	var genres: [Genre]?
	var runtime: Int?
	
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
		case backdropPath = "backdrop_path"
		case genres
		case runtime
	}
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.id = try container.decode(Int.self, forKey: .id)
		self.title = try container.decode(String.self, forKey: .title)
		self.overview = try container.decode(String.self, forKey: .overview)
		self.popularity = try container.decode(Double.self, forKey: .popularity)
		self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
		self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
		self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
		self.genreIDS = try container.decodeIfPresent([Int].self, forKey: .genreIDS)
		self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
		self.genres = try container.decodeIfPresent([Genre].self, forKey: .genres)
		self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
	}
}

extension Movie {
	init(
		id: Int,
		title: String,
		overview: String,
		popularity: Double,
		posterPath: String?,
		releaseDate: String,
		voteAverage: Double,
		genreIDS: [Int]?,
		backdropPath: String?,
		runtime: Int?
	) {
		self.id = id
		self.title = title
		self.overview = overview
		self.popularity = popularity
		self.posterPath = posterPath
		self.releaseDate = releaseDate
		self.voteAverage = voteAverage
		self.genreIDS = genreIDS
		self.backdropPath = backdropPath
		self.genres = nil // Not stored in cache
		self.runtime = runtime
	}
}
