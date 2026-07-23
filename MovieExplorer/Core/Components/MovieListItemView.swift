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
			CachedImageView(path: movie.posterPath ?? "")
				.cornerRadius(8)
				.frame(width: 90, height: 140)
			
			VStack(alignment: .leading, spacing: 6) {
				Text(movie.title)
					.font(AppTypography.body)
					.lineLimit(2)
				
				ReleaseDateView(releaseDate: movie.formattedReleaseDate)
				
				RatingView(rating: movie.formattedRating)
				
				FlowLayout(horizontalSpacing: 6, verticalSpacing: 6) {
					ForEach(movieGenres, id: \.id) { genre in
						ChipView(
							text: genre.name ?? "",
						)
					}
				}
			}
			.padding(.vertical, 6)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
    }
	
	// MARK: - Helper computed property
		private var movieGenres: [Genre] {
			guard let genreIDS = movie.genreIDS else { return [] }
			
			return genreIDS.compactMap { genreID in
				genres.first { $0.id == genreID }
			}
		}
}
