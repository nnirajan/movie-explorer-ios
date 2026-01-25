//
//  GenreNetworkRepository.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 25/01/2026.
//

import Foundation

final class GenreNetworkRepository {
	// MARK: - Properties
	private let networkClient: NetworkClientProtocol
	
	// MARK: - Initialization
	init(networkClient: NetworkClientProtocol) {
		self.networkClient = networkClient
	}
	
	// MARK: - Public Methods
	
	/// Fetches genres from network API
	/// - Parameter request: Network request configuration
	/// - Returns: Array of Genre domain models
	/// - Throws: Network error if request fails
	func fetchGenres(request: NetworkRequest) async throws -> [Genre] {
		let response: GenreReponse = try await networkClient.execute(request)
		return response.genres
	}
}
