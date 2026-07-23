//
//  CachedImageView.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import SwiftUI
import Kingfisher

enum TMDBImageSize: String {
	case w185, w342, w500, w780, original
}

struct TMDBImageURLBuilder {
	static let baseURL = "https://image.tmdb.org/t/p/"

	static func url(
		path: String,
		size: TMDBImageSize = .w500
	) -> URL? {
		URL(string: baseURL + size.rawValue + path)
	}
}

struct CachedImageView: View {
	let path: String
	let size: TMDBImageSize

	init(
		path: String,
		size: TMDBImageSize = .w500
	) {
		self.path = path
		self.size = size
	}

	var body: some View {
		KFImage(
			TMDBImageURLBuilder.url(path: path, size: size)
		)
		.placeholder {
			Rectangle()
				.fill(Color.gray.opacity(0.25))
		}
		.cancelOnDisappear(true)
		.fade(duration: 0.25)
		.resizable()
		.clipped()
	}
}
