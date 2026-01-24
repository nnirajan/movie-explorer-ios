//
//  PaginatedListView.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import SwiftUI

enum SearchState: Equatable {
	case idle
	case insufficientInput(remaining: Int)
	case loading
	case loaded(hasMore: Bool, isFetchingMore: Bool)
	case empty
	case error(String)
}

// MARK: - PaginatedData
struct PaginatedData<T> {
	let items: [T]
	let currentPage: Int
	let totalPages: Int
	
	var hasMore: Bool {
		currentPage < totalPages
	}
}

// MARK: - PaginationStateView
struct PaginationStateView<Data, Content: View, EmptyContent: View>: View {
	let state: SearchState
	let items: [Data]
	@ViewBuilder let content: ([Data], Bool, Bool) -> Content
	@ViewBuilder let emptyView: () -> EmptyContent
	
	init(
		state: SearchState,
		items: [Data],
		@ViewBuilder content: @escaping ([Data], Bool, Bool) -> Content,
		@ViewBuilder emptyView: @escaping () -> EmptyContent = { EmptyView() }
	) {
		self.state = state
		self.items = items
		self.content = content
		self.emptyView = emptyView
	}
	
	var body: some View {
		Group {
			switch state {
			case .idle:
				PlaceholderView(
					icon: "magnifyingglass",
					title: "Start Searching",
					message: "Enter at least 3 characters to begin"
				)
				
			case .insufficientInput(let remaining):
				PlaceholderView(
					icon: "text.cursor",
					title: "Keep Typing...",
					message: "Enter \(remaining) more character\(remaining == 1 ? "" : "s")"
				)
				
			case .loading:
				ProgressView("Loading...")
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.padding(.top, 100)
				
			case .loaded(let hasMore, let isFetchingMore):
				content(items, hasMore, isFetchingMore)
				
			case .empty:
				emptyView()
				
			case .error(let message):
				PlaceholderView(
					icon: "exclamationmark.triangle",
					title: "Error",
					message: message
				)
			}
		}
	}
}

// MARK: - PaginatedListView
struct PaginatedListView<Item: Identifiable, ItemView: View>: View {
	let items: [Item]
	let hasMore: Bool
	let isFetchingMore: Bool
	@ViewBuilder let itemView: (Item) -> ItemView
	let onLoadMore: () -> Void
	
	var body: some View {
		LazyVStack(alignment: .leading, spacing: 10) {
			ForEach(items) { item in
				itemView(item)
					.onAppear {
						if item.id == items.last?.id, hasMore, !isFetchingMore {
							onLoadMore()
						}
					}
			}
			
			if isFetchingMore {
				CircularLoaderView()
					.frame(maxWidth: .infinity)
			}
		}
	}
}

// MARK: - PlaceholderView
struct PlaceholderView: View {
	let icon: String
	let title: String
	let message: String
	
	var body: some View {
		VStack(spacing: 16) {
			Image(systemName: icon)
				.font(.system(size: 60))
				.foregroundStyle(.secondary)
			
			Text(title)
				.font(.title2)
				.fontWeight(.semibold)
			
			Text(message)
				.font(.subheadline)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
				.padding(.horizontal, 40)
		}
		.frame(maxWidth: .infinity)
		.padding(.top, 100)
	}
}

// MARK: - Searchable Protocol
protocol Searchable: AnyObject {
	associatedtype ResultType
	var searchText: String { get set }
	var searchState: SearchState { get set }
	func handleSearchTextChange(_ newValue: String)
	func performSearch(loadMore: Bool) async
}

extension Searchable {
	@MainActor
	func debounceSearch(
		minCharacters: Int = 3,
		debounceInterval: Duration = .milliseconds(500),
		searchTask: inout Task<Void, Never>?
	) {
		searchTask?.cancel()
		
		let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
		
		guard !trimmed.isEmpty else {
			searchState = .idle
			return
		}
		
		guard trimmed.count >= minCharacters else {
			searchState = .insufficientInput(remaining: minCharacters - trimmed.count)
			return
		}
		
		searchTask = Task { @MainActor in
			try? await Task.sleep(for: debounceInterval)
			guard !Task.isCancelled else { return }
			await performSearch(loadMore: false)
		}
	}
}

