//
//  SearchRequest.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

enum SearchRequest: NetworkRequest {
	case searchMovie(Parameters)
	
	var path: String {
		switch self {
		case .searchMovie:
			"search/movie"
		}
	}
	
	var method: HTTPMethod {
		switch self {
		case .searchMovie:
			return .get
		}
	}
	
	var encoders: [EncoderType] {
		switch self {
		case .searchMovie(let params):
			[.url(params)]
		}
	}
}
