//
//  ResponseValidator.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import Foundation

// MARK: - Response Validator Protocol
protocol ResponseValidator {
	func validate(request: URLRequest, response: HTTPURLResponse, data: Data?) throws
}

// MARK: - Default Response Validator
final class DefaultResponseValidator: ResponseValidator {
	private let acceptableStatusCodes: Range<Int>
	
	init(acceptableStatusCodes: Range<Int> = 200..<300) {
		self.acceptableStatusCodes = acceptableStatusCodes
	}
	
	func validate(request: URLRequest, response: HTTPURLResponse, data: Data?) throws {
		guard acceptableStatusCodes.contains(response.statusCode) else {
			throw NetworkError.httpError(statusCode: response.statusCode, data: data)
		}
	}
}
