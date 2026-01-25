//
//  BaseView.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 23/01/2026.
//

import SwiftUI

struct BaseView<Content: View, EmptyContent: View, VM: BaseViewModel>: View {
	@State var viewModel: VM
	
	let isRefreshable: Bool
	let content: () -> Content
	let emptyView: () -> EmptyContent
	let loadData: (() async -> Void)?
	
	init(
		viewModel: VM,
		isRefreshable: Bool = false,
		@ViewBuilder content: @escaping () -> Content,
		@ViewBuilder emptyView: @escaping () -> EmptyContent = { EmptyView() },
		loadData: (() async -> Void)? = nil
	) {
		self.viewModel = viewModel
		self.isRefreshable = isRefreshable
		self.content = content
		self.emptyView = emptyView
		self.loadData = loadData
	}
	
	var body: some View {
		VStack {
			switch viewModel.state {
			case .idle:
				EmptyView()
				
			case .loading:
				loaderView
				
			case .content:
				mainContent
				
			case .empty:
				emptyView()
				
			case .error(let error):
				ContentUnavailableStateView(
					title: error.title,
					message: error.message
				) {
					Task {
						await loadData?()
					}
				}
			}
		}
		.task {
			await runInitialLoadIfNeeded()
		}
		.animation(.easeInOut, value: viewModel.state)
	}
	
	@ViewBuilder
	private var mainContent: some View {
		Group {
			if isRefreshable, let loadData = loadData {
				content()
					.refreshable {
						guard viewModel.state != .loading else { return }
						await loadData()
					}
			} else {
				content()
			}
		}
	}
	
	@MainActor
	private func runInitialLoadIfNeeded() async {
		guard viewModel.state == .idle else { return }
		await loadData?()
	}
	
	private var loaderView: some View {
		Color.black.opacity(0.3)
			.ignoresSafeArea()
			.overlay {
				CircularLoaderView()
			}
	}
}
