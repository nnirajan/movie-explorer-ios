//
//  AppDependencyContainer.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import Foundation

/// Base protocol for all dependency containers
protocol DependencyContainer {
	var networkClient: NetworkClientProtocol { get }
}

// MARK: - NetworkConfigurationFactory
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

// MARK: - AppDependencyContainer
final class AppDependencyContainer: DependencyContainer {
	// MARK: - Singleton
	static let shared = AppDependencyContainer()
	
	// MARK: - Public Dependencies
	private(set) lazy var networkClient: NetworkClientProtocol = {
		NetworkClient(configuration: networkConfiguration)
	}()
	
	// MARK: - Properties
	private let environment: EnvironmentType
	private let networkConfiguration: NetworkConfiguration
	
	// MARK: - Initialization
	private init() {
		self.environment = BuildConfiguration.getAppEnvironment()
		
		// Setup network configuration
		do {
			let baseURL = try BuildConfiguration.getBaseURL()
			let apiKey = try BuildConfiguration.getAPIKey()
			
			self.networkConfiguration = NetworkConfigurationFactory.makeConfiguration(
				baseURL: baseURL,
				apiKey: apiKey,
				environment: environment
			)
		} catch {
			fatalError("Failed to configure network: \(error.localizedDescription)")
		}
	}
}
