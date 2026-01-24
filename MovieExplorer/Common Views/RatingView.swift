//
//  RatingView.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import SwiftUI

struct RatingView: View {
	var rating: String
	
    var body: some View {
		HStack(alignment: .center, spacing: 2) {
			Image(systemName: "star.fill")
				.resizable()
				.frame(width: 12, height: 12)
				.foregroundStyle(.yellow)
			
			Text(rating)
				.font(AppTypography.caption)
				.foregroundStyle(.secondary)
		}
    }
}

#Preview {
	RatingView(rating: "4.5")
}
