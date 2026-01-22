//
//  NetworkError.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 21/01/2026.
//

import Foundation

// MARK: - Network Error
enum NetworkError: Error {
	case invalidURL(urlString: String)
	case invalidResponse
	case httpError(statusCode: Int, data: Data?)
	case decodingError(Error)
	case encodingError(Error)
	case noData
	case requestAdaptationFailed(Error)
	case requestRetryFailed
	case cancelled
}
