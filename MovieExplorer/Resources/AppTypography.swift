//
//  AppTypography.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 23/01/2026.
//

import SwiftUI

enum AppTypography {
	// MARK: - Titles
	static let largeTitle = Font.system(size: 24, weight: .bold)
	static let title = Font.system(size: 20, weight: .semibold)
	static let subtitle = Font.system(size: 18, weight: .medium)

	// MARK: - Body
	static let body = Font.system(size: 16, weight: .regular)
	static let secondaryBody = Font.system(size: 14, weight: .regular)

	// MARK: - Small / Meta
	static let caption = Font.system(size: 12, weight: .regular)
	static let footnote = Font.system(size: 11, weight: .regular)
}
