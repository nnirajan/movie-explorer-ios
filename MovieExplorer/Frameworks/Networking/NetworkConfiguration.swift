//
//  NetworkConfiguration.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 21/01/2026.
//

import Foundation

// MARK: - URL Session Protocol
protocol URLSessionProtocol {
	func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

// MARK: - Network Configuration
struct NetworkConfiguration {
	let baseURL: URL
	let session: URLSessionProtocol
	let decoder: JSONDecoder
	let encoder: JSONEncoder
	let adapters: [RequestAdapter]
	let interceptors: [RequestInterceptor]
	let retrier: RequestRetrier?
	let validator: ResponseValidator?
	let defaultHeaders: HTTPHeaders
	
	init(
		baseURL: URL,
		session: URLSessionProtocol = URLSession.shared,
		decoder: JSONDecoder = JSONDecoder(),
		encoder: JSONEncoder = JSONEncoder(),
		adapters: [RequestAdapter] = [],
		interceptors: [RequestInterceptor] = [],
		retrier: RequestRetrier? = nil,
		validator: ResponseValidator? = nil,
		defaultHeaders: HTTPHeaders = [:]
	) {
		self.baseURL = baseURL
		self.session = session
		self.decoder = decoder
		self.encoder = encoder
		self.adapters = adapters
		self.interceptors = interceptors
		self.retrier = retrier
		self.validator = validator
		self.defaultHeaders = defaultHeaders
	}
}
