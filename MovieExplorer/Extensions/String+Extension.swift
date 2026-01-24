//
//  String+Extension.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import Foundation

extension String {
	func toDate(format: SupportedDateFormat) -> Date? {
		let formatter = DateFormatter()
		formatter.dateFormat = format.rawValue
		formatter.locale = .current
		return formatter.date(from: self)
	}
}
