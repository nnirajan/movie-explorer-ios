//
//  NetworkConfigurationFactory.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

final class NetworkConfigurationFactory {
	static func makeConfiguration(
		baseURL: URL,
		apiKey: String,
		environment: EnvironmentType
	) -> NetworkConfiguration {
		let adapters: [RequestAdapter] = []
		
		let retrier = RetryPolicy(
			maxRetryCount: 3,
			retryableStatusCodes: [408, 429, 500, 502, 503, 504],
			retryDelay: 1.0
		)
		
		let validator = DefaultResponseValidator()
		
		let defaultHeaders: HTTPHeaders = [
			"Accept": "application/json",
			"Authorization": "Bearer \(apiKey)",
			"Content-Type": "application/json"
		]
		
		let interceptors: [RequestInterceptor] = environment.isDebug
			? [LoggingInterceptor(logLevel: .verbose)]
			: [LoggingInterceptor(logLevel: .error)]
		
		return NetworkConfiguration(
			baseURL: baseURL,
			adapters: adapters,
			interceptors: interceptors,
			retrier: retrier,
			validator: validator,
			defaultHeaders: defaultHeaders
		)
	}
}
