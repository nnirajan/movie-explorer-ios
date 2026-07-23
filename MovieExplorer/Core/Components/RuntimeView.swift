//
//  Untitled.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import SwiftUI

struct RunTimeView: View {
	var runtime: Int
	
	var body: some View {
		HStack(alignment: .center, spacing: 4) {
			Image(systemName: "clock")
				.resizable()
				.frame(width: 16, height: 16)
			
			Text("\(runtime) minutes")
				.font(AppTypography.secondaryBody)
		}
		.foregroundStyle(.secondary)
	}
}

#Preview {
	RunTimeView(runtime: 128)
}
