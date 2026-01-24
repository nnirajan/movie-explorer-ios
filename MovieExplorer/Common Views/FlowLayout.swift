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
	var alignment: Alignment
	
	init(
		horizontalSpacing: CGFloat = 8,
		verticalSpacing: CGFloat = 8,
		alignment: Alignment = .leading
	) {
		self.horizontalSpacing = horizontalSpacing
		self.verticalSpacing = verticalSpacing
		self.alignment = alignment
	}
	
	func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
		let result = FlowResult(
			in: proposal.width ?? 0,
			subviews: subviews,
			horizontalSpacing: horizontalSpacing,
			verticalSpacing: verticalSpacing,
			alignment: alignment
		)
		return result.size
	}
	
	func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
		let result = FlowResult(
			in: bounds.width,
			subviews: subviews,
			horizontalSpacing: horizontalSpacing,
			verticalSpacing: verticalSpacing,
			alignment: alignment
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
		
		init(
			in maxWidth: CGFloat,
			subviews: Subviews,
			horizontalSpacing: CGFloat,
			verticalSpacing: CGFloat,
			alignment: Alignment
		) {
			var xPos: CGFloat = 0
			var yPos: CGFloat = 0
			var lineHeight: CGFloat = 0
			var currentLineFrames: [CGRect] = []
			var allLines: [[CGRect]] = []
			
			for subview in subviews {
				let size = subview.sizeThatFits(.unspecified)
				
				// Check if we need to wrap to next line
				if xPos + size.width > maxWidth && xPos > 0 {
					// Store current line before wrapping
					allLines.append(currentLineFrames)
					currentLineFrames = []
					
					xPos = 0
					yPos += lineHeight + verticalSpacing
					lineHeight = 0
				}
				
				let frame = CGRect(x: xPos, y: yPos, width: size.width, height: size.height)
				currentLineFrames.append(frame)
				
				lineHeight = max(lineHeight, size.height)
				xPos += size.width + horizontalSpacing
			}
			
			// Add the last line
			if !currentLineFrames.isEmpty {
				allLines.append(currentLineFrames)
			}
			
			// Apply alignment to each line
			for lineFrames in allLines {
				let lineWidth = lineFrames.last!.maxX
				let offset = calculateOffset(
					lineWidth: lineWidth,
					maxWidth: maxWidth,
					alignment: alignment
				)
				
				for frame in lineFrames {
					frames.append(frame.offsetBy(dx: offset, dy: 0))
				}
			}
			
			self.size = CGSize(width: maxWidth, height: yPos + lineHeight)
		}
		
		private func calculateOffset(lineWidth: CGFloat, maxWidth: CGFloat, alignment: Alignment) -> CGFloat {
			switch alignment {
			case .leading:
				return 0
			case .center:
				return (maxWidth - lineWidth) / 2
			case .trailing:
				return maxWidth - lineWidth
			default:
				// For custom alignments, default to leading
				if alignment.horizontal == .leading {
					return 0
				} else if alignment.horizontal == .trailing {
					return maxWidth - lineWidth
				} else {
					return (maxWidth - lineWidth) / 2
				}
			}
		}
	}
}
