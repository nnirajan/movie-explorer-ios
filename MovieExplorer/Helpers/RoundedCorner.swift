//
//  RoundedCorner.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import SwiftUI

struct RoundedCorner: Shape {
	var radius: CGFloat = 10
	var corners: UIRectCorner = .allCorners
	
	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(
			roundedRect: rect,
			byRoundingCorners: corners,
			cornerRadii: CGSize(width: radius, height: radius)
		)
		return Path(path.cgPath)
	}
}
