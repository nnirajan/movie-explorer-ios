//
//  NetworkClient.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 21/01/2026.
//

import Foundation

// MARK: - Network Client Protocol
protocol NetworkClientProtocol {
	func execute<T: Decodable>(_ request: NetworkRequest) async throws -> T
	func execute(_ request: NetworkRequest) async throws -> Data
}

// MARK: - Network Client
final class NetworkClient: NetworkClientProtocol {
	private let configuration: NetworkConfiguration
	private let requestBuilder: RequestBuilder
	
	init(configuration: NetworkConfiguration) {
		self.configuration = configuration
		self.requestBuilder = RequestBuilder(baseURL: configuration.baseURL)
	}
	
	convenience init(baseURL: URL) {
		let config = NetworkConfiguration(baseURL: baseURL)
		self.init(configuration: config)
	}
	
	func execute<T: Decodable>(_ request: NetworkRequest) async throws -> T {
		let data = try await execute(request)
		
		do {
			return try configuration.decoder.decode(T.self, from: data)
		} catch {
			throw NetworkError.decodingError(error)
		}
	}
	
	func execute(_ request: NetworkRequest) async throws -> Data {
		var urlRequest = try requestBuilder.build(from: request, defaultHeaders: configuration.defaultHeaders)
		
		// Apply adapters
		urlRequest = try await applyAdapters(to: urlRequest)
		
		// Execute with retry logic
		return try await executeWithRetry(urlRequest, retryCount: 0)
	}
	
	private func executeWithRetry(_ request: URLRequest, retryCount: Int) async throws -> Data {
		var httpResponse: HTTPURLResponse?
		var responseData: Data?

		do {
			let (data, response) = try await configuration.session.data(for: request)
			responseData = data

			guard let validResponse = response as? HTTPURLResponse else {
				throw NetworkError.invalidResponse
			}

			httpResponse = validResponse

			// Validate response
			if let validator = configuration.validator {
				try validator.validate(request: request, response: validResponse, data: data)
			} else {
				try defaultValidation(response: validResponse, data: data)
			}

			// Call interceptors on success
			try await applyInterceptors(request: request, response: validResponse, data: data, error: nil)

			return data

		} catch {
			// Call interceptors on error
			try await applyInterceptors(request: request, response: httpResponse, data: responseData, error: error)

			// Check if should retry
			if let retrier = configuration.retrier,
			   await retrier.shouldRetry(request: request, response: httpResponse, error: error, retryCount: retryCount) {
				return try await executeWithRetry(request, retryCount: retryCount + 1)
			}

			throw error
		}
	}

	private func applyAdapters(to request: URLRequest) async throws -> URLRequest {
		var urlRequest = request
		
		for adapter in configuration.adapters {
			do {
				urlRequest = try await adapter.adapt(urlRequest)
			} catch {
				throw NetworkError.requestAdaptationFailed(error)
			}
		}
		
		return urlRequest
	}
	
	private func applyInterceptors(
		request: URLRequest,
		response: HTTPURLResponse?,
		data: Data?,
		error: Error?
	) async throws {
		for interceptor in configuration.interceptors {
			try await interceptor.intercept(request, response: response, data: data, error: error)
		}
	}
	
	private func defaultValidation(response: HTTPURLResponse, data: Data?) throws {
		guard (200...299).contains(response.statusCode) else {
			throw NetworkError.httpError(statusCode: response.statusCode, data: data)
		}
	}
}
