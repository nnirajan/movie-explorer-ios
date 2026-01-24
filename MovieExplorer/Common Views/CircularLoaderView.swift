//
//  CircularLoaderView.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import SwiftUI

struct CircularLoaderView: View {
	@State private var isAnimating = false
	
	var body: some View {
		Circle()
			.trim(from: 0.0, to: 0.7)
			.stroke(
				AngularGradient(
					gradient: Gradient(colors: [.red.opacity(0.2), .white]),
					center: .center
				),
				style: StrokeStyle(
					lineWidth: 4,
					lineCap: .round
				)
			)
			.frame(width: 44, height: 44)
			.rotationEffect(.degrees(isAnimating ? 360 : 0))
			.animation(
				.linear(duration: 0.9)
				.repeatForever(autoreverses: false),
				value: isAnimating
			)
			.onAppear {
				isAnimating = true
			}
	}
}
