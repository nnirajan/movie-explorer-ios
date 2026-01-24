//
//  SearchViewModel.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 24/01/2026.
//

import Foundation

@Observable
class SearchViewModel: BaseViewModel, Searchable {
	typealias ResultType = [Movie]
	
	// MARK: - properties
	private let searchRepository: SearchRepository
	private var searchTask: Task<Void, Never>?
	private var paginatedResponse: PaginatedData<Movie>?
	
	var searchText: String = ""
	var searchState: SearchState = .idle
	var movies: [Movie] = []
	
	// MARK: - init
	init(searchRepository: SearchRepository) {
		self.searchRepository = searchRepository
		super.init()
		setContent()
	}
	
	@MainActor
	func handleSearchTextChange(_ newValue: String) {
		debounceSearch(searchTask: &searchTask)
	}
	
	@MainActor
	func performSearch(loadMore: Bool = false) async {
		let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
		
		guard trimmed.count >= 3 else { return }
		
		let page: Int
		
		if loadMore {
			guard case .loaded(true, false) = searchState,
				  let response = paginatedResponse
			else {
				return
			}
			
			page = response.currentPage + 1
			searchState = .loaded(hasMore: true, isFetchingMore: true)
		} else {
			page = 1
			movies = []
			searchState = .loading
		}
		
		do {
			let params: Parameters = [
				"query": trimmed,
				"page": page
			]
			
			let request = SearchRequest.searchMovie(params)
			let response = try await searchRepository.getSearchMovies(request: request)
			
			let newMovies = response.results
			let paginatedData = PaginatedData(
				items: newMovies,
				currentPage: response.page,
				totalPages: response.totalPages
			)
			
			if loadMore {
				movies.append(contentsOf: newMovies)
				
				paginatedResponse = PaginatedData(
					items: movies,
					currentPage: response.page,
					totalPages: response.totalPages
				)
				
				searchState = .loaded(
					hasMore: paginatedData.hasMore,
					isFetchingMore: false
				)
			} else {
				movies = newMovies
				
				paginatedResponse = paginatedData
				
				searchState = newMovies.isEmpty ? .empty : .loaded(
					hasMore: paginatedData.hasMore,
					isFetchingMore: false
				)
			}
		} catch {
			handleError(loadMore: loadMore, error: error)
		}
	}
	
	@MainActor
	private func handleError(loadMore: Bool, error: Error) {
		if loadMore {
			searchState = .loaded(hasMore: false, isFetchingMore: false)
		} else {
			movies = []
			searchState = .error(
				error.localizedDescription.isEmpty ?
				"Unable to search. Please try again." :
				error.localizedDescription
			)
		}
	}
	
	deinit {
		searchTask?.cancel()
	}
}
