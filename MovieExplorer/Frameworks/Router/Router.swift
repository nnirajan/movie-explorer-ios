//
//  NewRouter.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import SwiftUI
import Combine

// MARK: - Route Protocol
/// Protocol that all routes must conform to
public protocol Route: Hashable, Identifiable {
	var id: String { get }
}

// MARK: - Router
/// Main navigation router class that manages the navigation stack
@MainActor
public final class Router<R: Route>: ObservableObject {

	// MARK: - Published Properties
	@Published public var path: [R] = []
	@Published public var sheet: R?
	@Published public var fullScreenCover: R?

	// MARK: - Initializer
	public init() {}

	// MARK: - Stack Management

	/// Push a new route onto the navigation stack
	public func push(_ route: R) {
		path.append(route)
	}

	/// Pop the top route from the stack
	public func pop() {
		guard !path.isEmpty else { return }
		path.removeLast()
	}

	/// Pop to root (remove all routes from stack)
	public func popToRoot() {
		path.removeAll()
	}

	/// Pop to a specific route in the stack
	/// - Parameter routeId: The ID of the route to pop to
	public func popTo(_ routeId: String) {
		guard let index = path.firstIndex(where: { $0.id == routeId }) else { return }
		path.removeSubrange((index + 1)...)
	}

	/// Pop to a specific route type
	/// - Parameter route: The route to pop to
	public func popTo(_ route: R) {
		popTo(route.id)
	}

	/// Pop multiple screens
	/// - Parameter count: Number of screens to pop
	public func pop(count: Int) {
		guard count > 0, count <= path.count else { return }
		path.removeLast(count)
	}

	/// Replace the current route with a new one
	/// - Parameter route: The new route to replace with
	public func replace(with route: R) {
		guard !path.isEmpty else {
			push(route)
			return
		}
		path[path.count - 1] = route
	}

	/// Replace entire navigation stack with new routes
	/// - Parameter routes: Array of routes to replace the stack with
	public func replaceAll(with routes: [R]) {
		path = routes
	}

	/// Set specific path
	/// - Parameter newPath: New navigation path
	public func setPath(_ newPath: [R]) {
		path = newPath
	}

	// MARK: - Sheet Management

	/// Present a route as a sheet
	/// - Parameter route: The route to present
	public func presentSheet(_ route: R) {
		sheet = route
	}

	/// Dismiss the currently presented sheet
	public func dismissSheet() {
		sheet = nil
	}

	// MARK: - Full Screen Cover Management

	/// Present a route as a full screen cover
	/// - Parameter route: The route to present
	public func presentFullScreenCover(_ route: R) {
		fullScreenCover = route
	}

	/// Dismiss the currently presented full screen cover
	public func dismissFullScreenCover() {
		fullScreenCover = nil
	}

	// MARK: - Utility Methods

	/// Get the current route (top of stack)
	public var currentRoute: R? {
		path.last
	}

	/// Get the root route
	public var rootRoute: R? {
		path.first
	}

	/// Check if can pop
	public var canPop: Bool {
		!path.isEmpty
	}

	/// Get stack depth
	public var depth: Int {
		path.count
	}

	/// Check if a specific route exists in the stack
	/// - Parameter routeId: The ID of the route to check
	/// - Returns: True if route exists in stack
	public func contains(routeId: String) -> Bool {
		path.contains(where: { $0.id == routeId })
	}

	/// Check if a specific route exists in the stack
	/// - Parameter route: The route to check
	/// - Returns: True if route exists in stack
	public func contains(_ route: R) -> Bool {
		path.contains(route)
	}
}

// MARK: - NavigationStackRouter View
/// A view that wraps NavigationStack with Router capabilities
public struct NavigationStackRouter<R: Route, Root: View, Destination: View>: View {
	@ObservedObject private var router: Router<R>
	private let root: (Router<R>) -> Root
	private let buildDestination: (R, Router<R>) -> Destination

	public init(
		router: Router<R>,
		@ViewBuilder root: @escaping (Router<R>) -> Root,
		@ViewBuilder destination: @escaping (R, Router<R>) -> Destination
	) {
		self.router = router
		self.root = root
		self.buildDestination = destination
	}

	public var body: some View {
		NavigationStack(path: $router.path) {
			root(router)
				.navigationDestination(for: R.self) { route in
					buildDestination(route, router)
				}
				.sheet(item: $router.sheet) { route in
					buildDestination(route, router)
				}
				.fullScreenCover(item: $router.fullScreenCover) { route in
					buildDestination(route, router)
				}
		}
	}
}
