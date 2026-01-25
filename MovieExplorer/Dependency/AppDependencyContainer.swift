//
//  AppDependencyContainer.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import Foundation
import SwiftData

/// Base protocol for all dependency containers
protocol DependencyContainer {
	var networkClient: NetworkClientProtocol { get }
}

// MARK: - AppDependencyContainer
final class AppDependencyContainer: DependencyContainer {
	// MARK: - Singleton
	static let shared = AppDependencyContainer()
	
	// MARK: - Public Dependencies
	private(set) lazy var networkClient: NetworkClientProtocol = {
		NetworkClient(configuration: networkConfiguration)
	}()
	
	// MARK: - Properties
	private let environment: EnvironmentType
	private let networkConfiguration: NetworkConfiguration
	
	// MARK: - Initialization
	private init() {
		self.environment = BuildConfiguration.getAppEnvironment()
		
		// Setup network configuration
		do {
			let baseURL = try BuildConfiguration.getBaseURL()
			let apiKey = try BuildConfiguration.getAPIKey()
			
			self.networkConfiguration = NetworkConfigurationFactory.makeConfiguration(
				baseURL: baseURL,
				apiKey: apiKey,
				environment: environment
			)
		} catch {
			fatalError("Failed to configure network: \(error.localizedDescription)")
		}
	}
}

// MARK: - Storage
extension AppDependencyContainer {
	/// Shared ModelContainer for all SwiftData operations
	var modelContainer: ModelContainer {
		let schema = Schema(
			[
				GenreEntity.self,
				MovieEntity.self,
				FavouriteMovieEntity.self
			]
		)
		
		let modelConfiguration = ModelConfiguration(
			schema: schema,
			isStoredInMemoryOnly: false,
			allowsSave: true,
			cloudKitDatabase: .none  // ⬅️ Add this
		)
		
		do {
			let container = try ModelContainer(
				for: schema,
				configurations: [modelConfiguration]
			)
			return container
		} catch {
			print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
			print("❌ ModelContainer creation failed: \(error)")
			print("❌ Error details: \(error.localizedDescription)")
			fatalError("Failed to create ModelContainer: \(error)")
		}
	}
}

// MARK: - Repository Factories
extension AppDependencyContainer {
	// MARK: - Genre Repository
	func makeGenreRepository() -> GenreRepository {
		GenreRepositoryImpl(
			networkClient: networkClient,
			localRepository: GenreLocalRepository(
				dataSource: GenreLocalDataSource(
					modelContainer: modelContainer
				)
			)
		)
	}
	
	// MARK: - Movie Repository
	func makeMovieRepository() -> MovieRepository {
		MovieRepositoryImpl(
			networkClient: networkClient,
			localRepository: MovieLocalRepository(
				dataSource: MovieLocalDataSource(
					modelContainer: modelContainer
				)
			)
		)
	}
	
	// MARK: - Search Repository
	func makeSearchRepository() -> SearchRepository {
		SearchRepositoryImpl(
			networkClient: networkClient
		)
	}
	
	func makeFavouriteRepository() -> FavouriteRepository {
		FavouriteRepositoryImpl(
			localDataSource: FavouriteLocalDataSource(
				modelContainer: modelContainer
			)
		)
	}
}

// MARK: - ViewModel Factories
extension AppDependencyContainer {
	func makeHomeViewModel() -> HomeViewModel {
		HomeViewModel(
			movieRepository: makeMovieRepository(),
			genreRepository: makeGenreRepository()
		)
	}
	
	func makeDetailViewModel(movieID: Int) -> DetailViewModel {
		DetailViewModel(
			movieID: movieID,
			movieRepository: makeMovieRepository(),
			favouriteRepository: makeFavouriteRepository()
		)
	}
	
	func makeSearchViewModel() -> SearchViewModel {
		SearchViewModel(
			searchRepository: makeSearchRepository()
		)
	}
	
	func makeFavouriteViewModel() -> FavouriteViewModel {
		FavouriteViewModel(
			favouriteRepository: makeFavouriteRepository()
		)
	}
}
