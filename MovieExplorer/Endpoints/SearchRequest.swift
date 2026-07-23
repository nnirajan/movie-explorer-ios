//
//  SearchRequest.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

enum SearchRequest: NetworkRequest {
	case search(Parameters)
	
	var path: String {
		switch self {
		case .search:
			"search/movie"
		}
	}
	
	var method: HTTPMethod {
		switch self {
		case .search:
			return .get
		}
	}
	
	var encoders: [EncoderType] {
		switch self {
		case .search(let params):
			[.url(params)]
		}
	}
}
