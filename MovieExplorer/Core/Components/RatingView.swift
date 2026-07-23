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
		HStack(alignment: .center, spacing: 4) {
			Image(systemName: "star.fill")
				.resizable()
				.frame(width: 16, height: 16)
			
			Text(rating)
				.font(AppTypography.secondaryBody)
		}
		.foregroundStyle(.yellow)
    }
}

#Preview {
	RatingView(rating: "4.5")
}
