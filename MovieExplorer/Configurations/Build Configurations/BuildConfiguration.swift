//
//  BuildConfiguration.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 21/01/2026.
//

import Foundation

enum BuildConfigurationKey: String {
	case baseURL = "BASE_URL"
}

// MARK: - BuildConfiguration
struct BuildConfiguration {
	static func getValue<T>(for key: BuildConfigurationKey) throws -> T {
		guard let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? T else {
			throw AppError.custom(message: "Cannot find the key: \(key.rawValue) in info.plist")
		}
		
		return value
	}
}
