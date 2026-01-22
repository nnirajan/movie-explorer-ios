//
//  AppError.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 21/01/2026.
//

import Foundation

public enum AppError {
	case unknownError
	case failed
	case unauthenticated
	case custom(message: String)
}

extension AppError: LocalizedError {
	public var errorDescription: String? {
		switch self {
//		case .unknownError:
//			return .localized(.unknownError)
//			
//			String(localized:)
//		case .failed:
//			return .localized(.failed)
//		case .unauthenticated:
//			return ""
		case let .custom(message):
			return message
		default:
			return ""
		}
	}
}

