//
//  GenreRequest.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import Foundation

enum GenreRequest: NetworkRequest {
	case genre
	
	var path: String {
		switch self {
		case .genre:
			"genre/movie/list"
		}
	}
	
	var method: HTTPMethod {
		switch self {
		case .genre:
			return .get
		}
	}
	
	var encoders: [EncoderType] {
		switch self {
		case .genre:
			[]
		}
	}
}
