//
//  ReleaseDateView.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import SwiftUI

struct ReleaseDateView: View {
	var releaseDate: String
	
	var body: some View {
		HStack(alignment: .center, spacing: 4) {
			Image(systemName: "calendar")
				.resizable()
				.frame(width: 16, height: 16)
			
			Text(releaseDate)
				.font(AppTypography.secondaryBody)
		}
		.foregroundStyle(.secondary)
	}
}
