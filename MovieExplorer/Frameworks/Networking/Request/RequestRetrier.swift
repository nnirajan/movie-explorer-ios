//
//  RequestRetrier.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import Foundation

// MARK: - Request Retry Protocol
protocol RequestRetrier {
	func shouldRetry(request: URLRequest, response: HTTPURLResponse?, error: Error?, retryCount: Int) async -> Bool
}

// MARK: - Retry Policy
final class RetryPolicy: RequestRetrier {
	private let maxRetryCount: Int
	private let retryableStatusCodes: Set<Int>
	private let retryDelay: TimeInterval
	
	init(
		maxRetryCount: Int = 3,
		retryableStatusCodes: Set<Int> = [408, 429, 500, 502, 503, 504],
		retryDelay: TimeInterval = 1.0
	) {
		self.maxRetryCount = maxRetryCount
		self.retryableStatusCodes = retryableStatusCodes
		self.retryDelay = retryDelay
	}
	
	func shouldRetry(request: URLRequest, response: HTTPURLResponse?, error: Error?, retryCount: Int) async -> Bool {
		guard retryCount < maxRetryCount else { return false }
		
		if let statusCode = response?.statusCode, retryableStatusCodes.contains(statusCode) {
			try? await Task.sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))
			return true
		}
		
		if let urlError = error as? URLError {
			switch urlError.code {
			case .timedOut, .networkConnectionLost, .notConnectedToInternet:
				try? await Task.sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))
				return true
			default:
				return false
			}
		}
		
		return false
	}
}
