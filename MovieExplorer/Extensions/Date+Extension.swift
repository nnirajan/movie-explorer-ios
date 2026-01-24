//
//  Date+Extension.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import Foundation

public enum SupportedDateFormat: String {
	case yyyyMMdd = "yyyy-MM-dd"          // API format
	case ddMMyyyySlash = "dd/MM/yyyy"     // Custom display
	case MMMdyyyy = "MMM d, yyyy"         // e.g., Jan 12, 2024
	case full = "EEEE, MMM d, yyyy"       // e.g., Friday, Jan 12, 2024
}

extension Date {
	func toString(format: SupportedDateFormat) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = format.rawValue
		formatter.locale = .current
		return formatter.string(from: self)
	}
}
