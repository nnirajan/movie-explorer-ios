//
//  MovieRequest.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import Foundation

enum MovieRequest: NetworkRequest {
	case nowPlaying
	case popular(Parameters)
	case genre
	
	var path: String {
		switch self {
		case .nowPlaying:
			"movie/now_playing"
		case .popular:
			"movie/popular"
		case .genre:
			"genre/movie/list"
		}
	}
	
	var method: HTTPMethod {
		switch self {
		case .nowPlaying, .popular, .genre:
			return .get
		}
	}
	
	var encoders: [EncoderType] {
		switch self {
		case .nowPlaying, .genre:
			[]
		case .popular(let params):
			[.url(params)]
		}
	}
}
