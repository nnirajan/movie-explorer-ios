//
//  BuildConfiguration.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 21/01/2026.
//

import Foundation

enum BuildConfigurationKey: String {
	case baseURL = "BASE_URL"
	case version = "VERSION"
	case apiKey = "API_KEY"
	case appEnv = "APP_ENV"
}

// MARK: - Environment Type
enum EnvironmentType: String {
	case dev = "DEV"
	case stage = "STAGE"
	case uat = "UAT"
	case prod = "PROD"

	var isDebug: Bool {
		switch self {
		case .dev, .stage, .uat:
			return true
		case .prod:
			return false
		}
	}
}

// MARK: - BuildConfiguration
struct BuildConfiguration {
	static func getValue<T>(for key: BuildConfigurationKey) throws -> T {
		guard let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? T else {
			throw AppError.missingConfiguration(key: key.rawValue)
		}

		return value
	}

	static func getBaseURL() throws -> URL {
		let baseURLString: String = try getValue(for: .baseURL)
		let version: String = try getValue(for: .version)
		let fullURLString = baseURLString + version

		guard let url = URL(string: fullURLString) else {
			throw NetworkError.invalidURL(urlString: fullURLString)
		}

		return url
	}

	static func getAPIKey() throws -> String {
		try getValue(for: .apiKey)
	}

	static func getAppEnvironment() -> EnvironmentType {
		let envString: String = (try? getValue(for: .appEnv)) ?? "PROD"
		return EnvironmentType(rawValue: envString) ?? .prod
	}
}
