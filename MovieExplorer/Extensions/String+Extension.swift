//
//  String+Extension.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import Foundation

extension String {
	func toDate(format: SupportedDateFormat) -> Date? {
		String.sharedFormatter.dateFormat = format.rawValue
		return String.sharedFormatter.date(from: self)
	}

	private static let sharedFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = .current
		return formatter
	}()
}
