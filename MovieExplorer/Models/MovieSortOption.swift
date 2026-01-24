//
//  MovieSortOption.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 23/01/2026.
//

enum MovieSortOption: String, CaseIterable {
	case originalTitleAsc = "original_title.asc"
	case originalTitleDesc = "original_title.desc"

	case popularityAsc = "popularity.asc"
	case popularityDesc = "popularity.desc"

	case revenueAsc = "revenue.asc"
	case revenueDesc = "revenue.desc"

	case releaseDateAsc = "primary_release_date.asc"
	case releaseDateDesc = "primary_release_date.desc"

	case titleAsc = "title.asc"
	case titleDesc = "title.desc"

	case voteAverageAsc = "vote_average.asc"
	case voteAverageDesc = "vote_average.desc"

	case voteCountAsc = "vote_count.asc"
	case voteCountDesc = "vote_count.desc"
}
