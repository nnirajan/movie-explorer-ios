//
//  HTTPMethod.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 21/01/2026.
//

public enum HTTPMethod: String {
	case get, post, put, delete, patch
	
	var identifier: String {
		switch self {
		case .get: return "GET"
		case .post: return "POST"
		case .put: return "PUT"
		case .delete: return "DELETE"
		case .patch: return "PATCH"
		}
	}
}
