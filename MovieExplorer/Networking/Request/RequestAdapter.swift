//
//  RequestAdapter.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import Foundation

// MARK: - Request Adapter Protocol
protocol RequestAdapter {
	func adapt(_ urlRequest: URLRequest) async throws -> URLRequest
}

// MARK: - Authentication Adapter
final class AuthenticationAdapter: RequestAdapter {
	private let tokenProvider: () async -> String?
	
	init(tokenProvider: @escaping () async -> String?) {
		self.tokenProvider = tokenProvider
	}
	
	func adapt(_ urlRequest: URLRequest) async throws -> URLRequest {
		var request = urlRequest
		
		if let token = await tokenProvider() {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		
		return request
	}
}
