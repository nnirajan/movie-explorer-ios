//
//  MovieListItemView.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import SwiftUI

struct MovieListItemView: View {
	var movie: Movie
	var genres: [Genre]
	
    var body: some View {
		HStack(alignment: .top, spacing: 12) {
			CachedImageView(path: movie.posterPath)
				.cornerRadius(8)
				.frame(width: 80, height: 120)
			
			VStack(alignment: .leading, spacing: 6) {
				Text(movie.title)
					.font(AppTypography.body)
					.lineLimit(2)
				
				Text(movie.formattedReleaseDate)
					.font(AppTypography.caption)
				
				RatingView(rating: movie.formattedRating)
				
				FlowLayout(horizontalSpacing: 6, verticalSpacing: 6) {
					ForEach(movieGenres, id: \.id) { genre in
						ChipView(
							text: genre.name ?? "",
						)
					}
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
    }
	
	// MARK: - Helper computed property
		private var movieGenres: [Genre] {
			movie.genreIDS.compactMap { genreID in
				genres.first { $0.id == genreID }
			}
		}
}
