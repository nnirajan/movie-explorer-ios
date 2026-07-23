//
//  AppError.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 21/01/2026.
//

import Foundation

public enum AppError {
	case missingConfiguration(key: String)
	case custom(message: String)
}

extension AppError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .missingConfiguration(let key):
			return "Cannot find the key: \(key) in Info.plist"
		case let .custom(message):
			return message
		}
	}
}
