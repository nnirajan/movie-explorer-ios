//
//  ChipView.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import SwiftUI

struct ChipView: View {
	let text: String
	
	var body: some View {
		Text(text)
			.font(AppTypography.caption)
			.padding(.horizontal, 8)
			.padding(.vertical, 4)
			.background(Color.gray.opacity(0.2))
			.foregroundColor(.primary)
			.cornerRadius(20)
	}
}
