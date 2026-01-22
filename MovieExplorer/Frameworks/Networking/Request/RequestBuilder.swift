//
//  RequestBuilder.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 21/01/2026.
//

import Foundation

// MARK: - RequestBuilder
final class RequestBuilder {
	private let baseURL: URL
	
	init(baseURL: URL) {
		self.baseURL = baseURL
	}
	
	func build(from request: NetworkRequest, defaultHeaders: HTTPHeaders) throws -> URLRequest {
		guard let url = URL(string: request.path, relativeTo: baseURL) else {
			throw NetworkError.invalidURL
		}
		
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = request.method.rawValue
		urlRequest.timeoutInterval = request.timeoutInterval
		
		// Apply default headers
		defaultHeaders.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
		
		// Apply request-specific headers
		request.headers?.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
		
		// Apply encoders
		for encoder in request.encoders {
			switch encoder {
			case .json(let params):
				try urlRequest.jsonEncoding(params)
				
			case .url(let params):
				try urlRequest.urlEncoding(params)
			}
		}
		
		return urlRequest
	}
}
