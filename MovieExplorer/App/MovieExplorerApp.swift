//
//  MovieExplorerApp.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 21/01/2026.
//

import SwiftUI
import Kingfisher

func configureKingfisher() {
	let cache = ImageCache.default

	// Memory cache
	cache.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024 // 300MB

	// Disk cache
	cache.diskStorage.config.sizeLimit = 1_000 * 1024 * 1024 // 1GB
	cache.diskStorage.config.expiration = .days(7)

	// Downloader
	ImageDownloader.default.downloadTimeout = 15.0
}

@main
struct MovieExplorerApp: App {
	init() {
		configureKingfisher()
	}
	
	var body: some Scene {
		WindowGroup {
			DashboardScreen()
		}
	}
}
