//
//  FlowLayout.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import SwiftUI

struct FlowLayout: Layout {
	var horizontalSpacing: CGFloat
	var verticalSpacing: CGFloat
	
	init(horizontalSpacing: CGFloat = 8, verticalSpacing: CGFloat = 8) {
		self.horizontalSpacing = horizontalSpacing
		self.verticalSpacing = verticalSpacing
	}
	
	func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
		let result = FlowResult(
			in: proposal.width ?? 0,
			subviews: subviews,
			horizontalSpacing: horizontalSpacing,
			verticalSpacing: verticalSpacing
		)
		return result.size
	}
	
	func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
		let result = FlowResult(
			in: bounds.width,
			subviews: subviews,
			horizontalSpacing: horizontalSpacing,
			verticalSpacing: verticalSpacing
		)
		for (index, subview) in subviews.enumerated() {
			subview.place(
				at: CGPoint(
					x: bounds.minX + result.frames[index].minX,
					y: bounds.minY + result.frames[index].minY
				),
				proposal: ProposedViewSize(result.frames[index].size)
			)
		}
	}
	
	struct FlowResult {
		var frames: [CGRect] = []
		var size: CGSize = .zero
		
		init(in maxWidth: CGFloat, subviews: Subviews, horizontalSpacing: CGFloat, verticalSpacing: CGFloat) {
			var xPos: CGFloat = 0
			var yPos: CGFloat = 0
			var lineHeight: CGFloat = 0
			
			for subview in subviews {
				let size = subview.sizeThatFits(.unspecified)
				
				// Check if we need to wrap to next line
				if xPos + size.width > maxWidth && xPos > 0 {
					xPos = 0
					yPos += lineHeight + verticalSpacing  // Use vertical spacing between rows
					lineHeight = 0
				}
				
				frames.append(CGRect(x: xPos, y: yPos, width: size.width, height: size.height))
				lineHeight = max(lineHeight, size.height)
				xPos += size.width + horizontalSpacing  // Use horizontal spacing between items
			}
			
			self.size = CGSize(width: maxWidth, height: yPos + lineHeight)
		}
	}
}
