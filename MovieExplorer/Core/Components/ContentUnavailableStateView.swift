//
//  ContentUnavailableStateView.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import SwiftUI

struct ContentUnavailableStateView: View {
	let title: String
	let message: String
	let retryAction: () -> Void
	
	var body: some View {
		VStack(spacing: 16) {
			Image(systemName: "xmark.circle")
				.font(.system(size: 40))
				.foregroundStyle(.red)
			
			Text(title)
				.font(.headline)
			
			Text(message)
				.font(.subheadline)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
			
			Button("Retry") {
				retryAction()
			}
			.buttonStyle(.borderedProminent)
		}
		.padding()
	}
}
