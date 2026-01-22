//
//  AppDependencyContainer.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import Foundation

protocol DependencyContainer {
	var networkClient: NetworkClientProtocol { get }
}

final class AppDependencyContainer: DependencyContainer {
	// MARK: - Singleton
	static let shared = AppDependencyContainer()

	// MARK: - Environment
	private let environment: EnvironmentType

	// MARK: - Network Client
	private(set) lazy var networkClient: NetworkClientProtocol = {
		let config = NetworkConfiguration(
			baseURL: baseURL,
			adapters: adapters,
			interceptors: interceptors,
			retrier: retrier,
			validator: validator,
			defaultHeaders: defaultHeaders
		)
		return NetworkClient(configuration: config)
	}()

	// MARK: - Private Properties
	private let baseURL: URL
	private let adapters: [RequestAdapter]
	private let interceptors: [RequestInterceptor]
	private let retrier: RequestRetrier?
	private let validator: ResponseValidator?
	private let defaultHeaders: HTTPHeaders

	// MARK: - Initialization
	private init() {
		// Get environment
		self.environment = BuildConfiguration.getAppEnvironment()

		// Get base URL from xcconfig
		do {
			self.baseURL = try BuildConfiguration.getBaseURL()
		} catch {
			fatalError("Failed to load BASE_URL from configuration: \(error.localizedDescription)")
		}

		// Setup adapters (no auth adapter needed - using default headers)
		self.adapters = []

		// Setup interceptors based on environment
		var interceptorList: [RequestInterceptor] = []

		if environment.isDebug {
			interceptorList.append(LoggingInterceptor(logLevel: .verbose))
		} else {
			interceptorList.append(LoggingInterceptor(logLevel: .error))
		}

		self.interceptors = interceptorList

		// Setup retry policy
		self.retrier = RetryPolicy(
			maxRetryCount: 3,
			retryableStatusCodes: [408, 429, 500, 502, 503, 504],
			retryDelay: 1.0
		)

		// Setup validator
		self.validator = DefaultResponseValidator()

		// Get API token from xcconfig
		let apiKey: String = (try? BuildConfiguration.getAPIKey()) ?? ""

		// Setup default headers with Bearer token
		self.defaultHeaders = [
			"Accept": "application/json",
			"Authorization": "Bearer \(apiKey)",
			"Content-Type": "application/json"
		]
	}
}
