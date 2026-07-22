//
//  BaseViewModel.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 23/01/2026.
//

import Foundation

enum ViewState: Equatable {
	case idle
	case loading
	case content
	case empty
	case error(ViewError)
}

struct ViewError: Equatable {
	let title: String
	let message: String
}

@Observable
class BaseViewModel {
	var state: ViewState = .idle
	/// Set to true in a subclass init to prevent BaseView from triggering loadData automatically.
	var skipInitialLoad: Bool = false

	init() {
		debugPrint("Initialized --> \(type(of: self))")
	}

	deinit {
		debugPrint("De-Initialized --> \(type(of: self))")
	}

	// MARK: - State helpers
	func setLoading() {
		state = .loading
	}

	func setContent() {
		state = .content
	}
	
	func setEmpty() {
		state = .empty
	}

	func setError(
		title: String = "Content Unavailable",
		message: String = "Something went wrong. Please try again."
	) {
		state = .error(
			ViewError(title: title, message: message)
		)
	}
}
