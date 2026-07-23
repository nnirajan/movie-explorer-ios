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
	// MARK: - Dependencies
	private(set) lazy var networkClient: NetworkClientProtocol = {
		NetworkClient(configuration: networkConfiguration)
	}()

	private(set) lazy var modelContainer: ModelContainer = {
		let schema = Schema(AppMigrationPlan.currentModels)

		let config = ModelConfiguration(
			schema: schema,
			isStoredInMemoryOnly: false,
			allowsSave: true,
			cloudKitDatabase: .none
		)

		do {
			return try ModelContainer(
				for: schema,
				migrationPlan: AppMigrationPlan.self,
				configurations: [config]
			)
		} catch let migrationError {
			#if DEBUG
			fatalError("[AppDependencyContainer] migration failed: \(migrationError)")
			#else
			print("[AppDependencyContainer] migration failed: \(migrationError)")

			do { try FileManager.default.removeItem(at: config.url) } catch {
				print("[AppDependencyContainer] store wipe failed: \(error)")
			}

			do {
				return try ModelContainer(for: schema, configurations: [config])
			} catch {
				fatalError("[AppDependencyContainer] failed to open store even after wipe: \(error)")
			}
			#endif
		}
	}()

	// MARK: - Properties
	private let environment: EnvironmentType
	private let networkConfiguration: NetworkConfiguration

	// MARK: - Initialization
	init() {
		self.environment = BuildConfiguration.getAppEnvironment()

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

// MARK: - Repository Factories
extension AppDependencyContainer {
	func makeGenreRepository() -> GenreRepository {
		GenreRepositoryImpl(
			networkClient: networkClient,
			store: GenreStoreImpl(
				dataSource: GenreDataSourceImpl(
					modelContainer: modelContainer
				)
			)
		)
	}

	func makeMovieRepository() -> MovieRepository {
		MovieRepositoryImpl(
			networkClient: networkClient,
			store: MovieStoreImpl(
				dataSource: MovieDataSourceImpl(
					modelContainer: modelContainer
				)
			)
		)
	}

	func makeSearchRepository() -> SearchRepository {
		SearchRepositoryImpl(networkClient: networkClient)
	}

	func makeFavouriteRepository() -> FavouriteRepository {
		FavouriteRepositoryImpl(
			store: FavouriteStoreImpl(
				dataSource: FavouriteDataSourceImpl(
					modelContainer: modelContainer
				)
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
		SearchViewModel(searchRepository: makeSearchRepository())
	}

	func makeFavouriteViewModel() -> FavouriteViewModel {
		FavouriteViewModel(favouriteRepository: makeFavouriteRepository())
	}
}
