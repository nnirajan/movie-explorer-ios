//
//  BaseView.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 23/01/2026.
//

import SwiftUI

struct BaseView<Content: View, VM: BaseViewModel>: View {
	@State var viewModel: VM

	let content: () -> Content
	let loadData: (() async -> Void)?

	init(
		viewModel: VM,
		@ViewBuilder content: @escaping () -> Content,
		loadData: (() async -> Void)? = nil
	) {
		self.viewModel = viewModel
		self.content = content
		self.loadData = loadData
	}

	var body: some View {
		ZStack {
			switch viewModel.state {
			case .idle:
				EmptyView()
				
			case .content:
				mainContent

			case .loading:
				loaderView

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

	private var mainContent: some View {
		content()
			.refreshable {
				guard viewModel.state != .loading else { return }
				await loadData?()
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




