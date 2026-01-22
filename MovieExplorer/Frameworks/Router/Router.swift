//
//  Router.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import SwiftUI
import Combine

//// MARK: - Route Protocol
///// Protocol that all routes must conform to
//public protocol Route: Hashable, Identifiable {
//	var id: String { get }
//}

//// MARK: - Navigation Action
//public enum NavigationAction {
//	case push
//	case pop
//	case popToRoot
//	case popTo(String) // Pop to specific route by ID
//	case replace
//	case replaceAll
//}
//
//// MARK: - Router
///// Main navigation router class that manages the navigation stack
//@MainActor
//public final class Router<R: Route>: ObservableObject {
//	// MARK: - Published Properties
//	@Published public var path: [R] = []
//	@Published public var sheet: R?
//	@Published public var fullScreenCover: R?
//
//	// MARK: - Private Properties
//	private var pathCancellable: AnyCancellable?
//
//	// MARK: - Initializer
//	public init() {}
//
//	// MARK: - Stack Management
//
//	/// Push a new route onto the navigation stack
//	public func push(_ route: R) {
//		path.append(route)
//	}
//
//	/// Pop the top route from the stack
//	public func pop() {
//		guard !path.isEmpty else { return }
//		path.removeLast()
//	}
//
//	/// Pop to root (remove all routes from stack)
//	public func popToRoot() {
//		path.removeAll()
//	}
//
//	/// Pop to a specific route in the stack
//	/// - Parameter routeId: The ID of the route to pop to
//	public func popTo(_ routeId: String) {
//		guard let index = path.firstIndex(where: { $0.id == routeId }) else { return }
//		path.removeSubrange((index + 1)...)
//	}
//
//	/// Pop to a specific route type
//	/// - Parameter route: The route to pop to
//	public func popTo(_ route: R) {
//		popTo(route.id)
//	}
//
//	/// Pop multiple screens
//	/// - Parameter count: Number of screens to pop
//	public func pop(count: Int) {
//		guard count > 0, count <= path.count else { return }
//		path.removeLast(count)
//	}
//
//	/// Replace the current route with a new one
//	/// - Parameter route: The new route to replace with
//	public func replace(with route: R) {
//		guard !path.isEmpty else {
//			push(route)
//			return
//		}
//		path[path.count - 1] = route
//	}
//
//	/// Replace entire navigation stack with new routes
//	/// - Parameter routes: Array of routes to replace the stack with
//	public func replaceAll(with routes: [R]) {
//		path = routes
//	}
//
//	/// Set specific path
//	/// - Parameter newPath: New navigation path
//	public func setPath(_ newPath: [R]) {
//		path = newPath
//	}
//
//	// MARK: - Sheet Management
//
//	/// Present a route as a sheet
//	/// - Parameter route: The route to present
//	public func presentSheet(_ route: R) {
//		sheet = route
//	}
//
//	/// Dismiss the currently presented sheet
//	public func dismissSheet() {
//		sheet = nil
//	}
//
//	// MARK: - Full Screen Cover Management
//
//	/// Present a route as a full screen cover
//	/// - Parameter route: The route to present
//	public func presentFullScreenCover(_ route: R) {
//		fullScreenCover = route
//	}
//
//	/// Dismiss the currently presented full screen cover
//	public func dismissFullScreenCover() {
//		fullScreenCover = nil
//	}
//
//	// MARK: - Utility Methods
//
//	/// Get the current route (top of stack)
//	public var currentRoute: R? {
//		path.last
//	}
//
//	/// Get the root route
//	public var rootRoute: R? {
//		path.first
//	}
//
//	/// Check if can pop
//	public var canPop: Bool {
//		!path.isEmpty
//	}
//
//	/// Get stack depth
//	public var depth: Int {
//		path.count
//	}
//
//	/// Check if a specific route exists in the stack
//	/// - Parameter routeId: The ID of the route to check
//	/// - Returns: True if route exists in stack
//	public func contains(routeId: String) -> Bool {
//		path.contains(where: { $0.id == routeId })
//	}
//
//	/// Check if a specific route exists in the stack
//	/// - Parameter route: The route to check
//	/// - Returns: True if route exists in stack
//	public func contains(_ route: R) -> Bool {
//		path.contains(route)
//	}
//}
//
//// MARK: - Router View Modifier
//public struct RouterViewModifier<R: Route, Destination: View>: ViewModifier {
//	@ObservedObject var router: Router<R>
//	let buildView: (R) -> Destination
//
//	public func body(content: Content) -> some View {
//		content
//			.navigationDestination(for: R.self) { route in
//				buildView(route)
//			}
//			.sheet(item: $router.sheet) { route in
//				buildView(route)
//			}
//			.fullScreenCover(item: $router.fullScreenCover) { route in
//				buildView(route)
//			}
//	}
//}
//
//// MARK: - View Extension
//public extension View {
//	/// Add navigation routing to a view
//	/// - Parameters:
//	///   - router: The router to use for navigation
//	///   - buildView: Closure that builds views for routes
//	func withRouter<R: Route, Destination: View>(
//		_ router: Router<R>,
//		@ViewBuilder buildView: @escaping (R) -> Destination
//	) -> some View {
//		self.modifier(RouterViewModifier(router: router, buildView: buildView))
//	}
//}
//
//// MARK: - NavigationStackRouter View
///// A view that wraps NavigationStack with Router capabilities
//public struct NavigationStackRouter<R: Route, Root: View, Destination: View>: View {
//	@ObservedObject private var router: Router<R>
//	private let root: Root
//	private let buildDestination: (R) -> Destination
//
//	public init(
//		router: Router<R>,
//		@ViewBuilder root: () -> Root,
//		@ViewBuilder destination: @escaping (R) -> Destination
//	) {
//		self.router = router
//		self.root = root()
//		self.buildDestination = destination
//	}
//
//	public var body: some View {
//		NavigationStack(path: $router.path) {
//			root
//				.withRouter(router, buildView: buildDestination)
//		}
//	}
//}
//
//// MARK: - Example Usage
//
//// Define your routes
//enum AppRoute: Route {
//	case home
//	case profile(userId: String)
//	case settings
//	case detail(id: Int)
//	case editProfile(userId: String)
//
//	var id: String {
//		switch self {
//		case .home:
//			return "home"
//		case .profile(let userId):
//			return "profile_\(userId)"
//		case .settings:
//			return "settings"
//		case .detail(let id):
//			return "detail_\(id)"
//		case .editProfile(let userId):
//			return "editProfile_\(userId)"
//		}
//	}
//}
//
//// Example root view
//struct ContentView: View {
//	@StateObject private var router = Router<AppRoute>()
//
//	var body: some View {
//		NavigationStackRouter(router: router) {
//			HomeView()
//				.environmentObject(router)
//		} destination: { route in
//			routeView(for: route)
//				.environmentObject(router)
//		}
//	}
//
//	@ViewBuilder
//	private func routeView(for route: AppRoute) -> some View {
//		switch route {
//		case .home:
//			HomeView()
//		case .profile(let userId):
//			ProfileView(userId: userId)
//		case .settings:
//			SettingsView()
//		case .detail(let id):
//			DetailView(id: id)
//		case .editProfile(let userId):
//			EditProfileView(userId: userId)
//		}
//	}
//}
//
//// Example views
//struct HomeView: View {
//	@EnvironmentObject var router: Router<AppRoute>
//
//	var body: some View {
//		VStack(spacing: 20) {
//			Text("Home")
//				.font(.largeTitle)
//
//			Button("Go to Profile") {
//				router.push(.profile(userId: "123"))
//			}
//
//			Button("Go to Settings") {
//				router.push(.settings)
//			}
//
//			Button("Present Sheet") {
//				router.presentSheet(.detail(id: 1))
//			}
//		}
//		.navigationTitle("Home")
//	}
//}
//
//struct ProfileView: View {
//	@EnvironmentObject var router: Router<AppRoute>
//	let userId: String
//
//	var body: some View {
//		VStack(spacing: 20) {
//			Text("Profile: \(userId)")
//				.font(.largeTitle)
//
//			Button("Edit Profile") {
//				router.push(.editProfile(userId: userId))
//			}
//
//			Button("Go to Settings") {
//				router.push(.settings)
//			}
//
//			Button("Pop") {
//				router.pop()
//			}
//
//			Button("Pop to Root") {
//				router.popToRoot()
//			}
//		}
//		.navigationTitle("Profile")
//	}
//}
//
//struct SettingsView: View {
//	@EnvironmentObject var router: Router<AppRoute>
//
//	var body: some View {
//		VStack(spacing: 20) {
//			Text("Settings")
//				.font(.largeTitle)
//
//			Button("Go to Detail") {
//				router.push(.detail(id: 42))
//			}
//
//			Button("Replace with Profile") {
//				router.replace(with: .profile(userId: "456"))
//			}
//
//			Button("Pop") {
//				router.pop()
//			}
//
//			Button("Pop to Root") {
//				router.popToRoot()
//			}
//
//			Text("Stack Depth: \(router.depth)")
//				.foregroundColor(.secondary)
//		}
//		.navigationTitle("Settings")
//	}
//}
//
//struct DetailView: View {
//	@EnvironmentObject var router: Router<AppRoute>
//	let id: Int
//
//	var body: some View {
//		VStack(spacing: 20) {
//			Text("Detail: \(id)")
//				.font(.largeTitle)
//
//			Button("Pop") {
//				router.pop()
//			}
//
//			Button("Pop to Root") {
//				router.popToRoot()
//			}
//
//			if router.contains(routeId: "profile_123") {
//				Button("Pop to Profile") {
//					router.popTo("profile_123")
//				}
//			}
//		}
//		.navigationTitle("Detail")
//	}
//}
//
//struct EditProfileView: View {
//	@EnvironmentObject var router: Router<AppRoute>
//	let userId: String
//
//	var body: some View {
//		VStack(spacing: 20) {
//			Text("Edit Profile: \(userId)")
//				.font(.largeTitle)
//
//			Button("Save & Go Back") {
//				router.pop()
//			}
//
//			Button("Cancel & Go to Root") {
//				router.popToRoot()
//			}
//
//			Button("Pop to Profile") {
//				router.popTo(.profile(userId: userId))
//			}
//		}
//		.navigationTitle("Edit Profile")
//	}
//}
