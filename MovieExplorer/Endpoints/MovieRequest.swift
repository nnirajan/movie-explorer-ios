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
	case detail(id: Int)
	case credits(id: Int)
	
	var path: String {
		switch self {
		case .nowPlaying:
			"movie/now_playing"
		case .popular:
			"movie/popular"
		case .detail(let id):
			"movie/\(id)"
		case .credits(let id):
			"movie/\(id)/credits"
		}
	}
	
	var method: HTTPMethod {
		switch self {
		case .nowPlaying, .popular, .detail, .credits:
			return .get
		}
	}
	
	var encoders: [EncoderType] {
		switch self {
		case .nowPlaying, .detail, .credits:
			[]
		case .popular(let params):
			[.url(params)]
		}
	}
}
