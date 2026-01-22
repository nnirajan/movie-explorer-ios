//
//  NewRouter.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

// swiftlint:disable file_length
//import SwiftUI
//import Combine
//
//// MARK: - Route Protocol
///// Protocol that all routes must conform to
//public protocol Route: Hashable, Identifiable {
//	var id: String { get }
//}
//
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
//	private let root: (Router<R>) -> Root
//	private let buildDestination: (R, Router<R>) -> Destination
//
//	public init(
//		router: Router<R>,
//		@ViewBuilder root: @escaping (Router<R>) -> Root,
//		@ViewBuilder destination: @escaping (R, Router<R>) -> Destination
//	) {
//		self.router = router
//		self.root = root
//		self.buildDestination = destination
//	}
//
//	public var body: some View {
//		NavigationStack(path: $router.path) {
//			root(router)
//				.navigationDestination(for: R.self) { route in
//					buildDestination(route, router)
//				}
//				.sheet(item: $router.sheet) { route in
//					buildDestination(route, router)
//				}
//				.fullScreenCover(item: $router.fullScreenCover) { route in
//					buildDestination(route, router)
//				}
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
//		NavigationStackRouter(
//			router: router,
//			root: { router in
//				HomeView(router: router)
//			},
//			destination: { route, router in
//				routeView(for: route, router: router)
//			}
//		)
//	}
//
//	@ViewBuilder
//	private func routeView(for route: AppRoute, router: Router<AppRoute>) -> some View {
//		switch route {
//		case .home:
//			HomeView(router: router)
//		case .profile(let userId):
//			ProfileView(userId: userId, router: router)
//		case .settings:
//			SettingsView(router: router)
//		case .detail(let id):
//			DetailView(id: id, router: router)
//		case .editProfile(let userId):
//			EditProfileView(userId: userId, router: router)
//		}
//	}
//}
//
//// Example views
//struct HomeView: View {
//	let router: Router<AppRoute>
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
//	let userId: String
//	let router: Router<AppRoute>
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
//	let router: Router<AppRoute>
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
//	let id: Int
//	let router: Router<AppRoute>
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
//	let userId: String
//	let router: Router<AppRoute>
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

// MARK: - Tab Router
/// Manages multiple routers for tab-based navigation
@MainActor
public final class TabRouter<Tab: Hashable>: ObservableObject {
	@Published public var selectedTab: Tab

	public init(selectedTab: Tab) {
		self.selectedTab = selectedTab
	}

	public func selectTab(_ tab: Tab) {
		selectedTab = tab
	}
}

// MARK: - Example Implementation

// Define tabs
enum AppTab: String, CaseIterable {
	case home
	case settings

	var title: String {
		switch self {
		case .home: return "Home"
		case .settings: return "Settings"
		}
	}

	var icon: String {
		switch self {
		case .home: return "house.fill"
		case .settings: return "gearshape.fill"
		}
	}
}

// Define routes for Home tab
enum HomeRoute: Route {
	case home
	case detail(id: Int)
	case nestedDetail(id: Int, subId: Int)

	var id: String {
		switch self {
		case .home:
			return "home"
		case .detail(let id):
			return "detail_\(id)"
		case .nestedDetail(let id, let subId):
			return "nestedDetail_\(id)_\(subId)"
		}
	}
}

// Define routes for Settings tab
enum SettingsRoute: Route {
	case settings
	case profile(userId: String)
	case editProfile(userId: String)
	case notifications

	var id: String {
		switch self {
		case .settings:
			return "settings"
		case .profile(let userId):
			return "profile_\(userId)"
		case .editProfile(let userId):
			return "editProfile_\(userId)"
		case .notifications:
			return "notifications"
		}
	}
}

// MARK: - Main App View with TabView
struct DashboardView: View {
	@StateObject private var tabRouter = TabRouter(selectedTab: AppTab.home)
	@StateObject private var homeRouter = Router<HomeRoute>()
	@StateObject private var settingsRouter = Router<SettingsRoute>()

	var body: some View {
		TabView(selection: $tabRouter.selectedTab) {
			// Home Tab
			NavigationStackRouter(router: homeRouter) { router in
				HomeTabView(router: router)
			} destination: { route, router in
				homeDestination(for: route, router: router)
			}
			.tabItem {
				Label(AppTab.home.title, systemImage: AppTab.home.icon)
			}
			.tag(AppTab.home)

			// Settings Tab
			NavigationStackRouter(router: settingsRouter) { router in
				SettingsTabView(router: router)
			} destination: { route, router in
				settingsDestination(for: route, router: router)
			}
			.tabItem {
				Label(AppTab.settings.title, systemImage: AppTab.settings.icon)
			}
			.tag(AppTab.settings)
		}
	}

	// MARK: - Home Destinations
	@ViewBuilder
	private func homeDestination(for route: HomeRoute, router: Router<HomeRoute>) -> some View {
		switch route {
		case .home:
			HomeTabView(router: router)
		case .detail(let id):
			DetailView(id: id, router: router)
		case .nestedDetail(let id, let subId):
			NestedDetailView(id: id, subId: subId, router: router)
		}
	}

	// MARK: - Settings Destinations
	@ViewBuilder
	private func settingsDestination(for route: SettingsRoute, router: Router<SettingsRoute>) -> some View {
		switch route {
		case .settings:
			SettingsTabView(router: router)
		case .profile(let userId):
			ProfileView(userId: userId, router: router)
		case .editProfile(let userId):
			EditProfileView(userId: userId, router: router)
		case .notifications:
			NotificationsView(router: router)
		}
	}
}

// MARK: - Home Tab Views

struct HomeTabView: View {
	let router: Router<HomeRoute>
	@State private var items = Array(1...20)

	var body: some View {
		List {
			Section {
				ForEach(items, id: \.self) { item in
					Button {
						router.push(.detail(id: item))
					} label: {
						HStack {
							Image(systemName: "doc.text.fill")
								.foregroundColor(.blue)
							Text("Item \(item)")
								.foregroundColor(.primary)
							Spacer()
							Image(systemName: "chevron.right")
								.font(.caption)
								.foregroundColor(.secondary)
						}
					}
				}
			} header: {
				Text("Items")
			}

			Section {
				Button {
					router.presentSheet(.detail(id: 999))
				} label: {
					Label("Show Modal", systemImage: "square.and.arrow.up")
				}
			}
		}
		.navigationTitle("Home")
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Text("Stack: \(router.depth)")
					.font(.caption)
					.foregroundColor(.secondary)
			}
		}
	}
}

struct DetailView: View {
	let id: Int
	let router: Router<HomeRoute>
	@State private var subItems = Array(1...10)

	var body: some View {
		List {
			Section {
				Text("This is detail view for item \(id)")
					.font(.body)
			}

			Section {
				ForEach(subItems, id: \.self) { subItem in
					Button {
						router.push(.nestedDetail(id: id, subId: subItem))
					} label: {
						HStack {
							Image(systemName: "doc.fill")
								.foregroundColor(.green)
							Text("Sub-item \(subItem)")
								.foregroundColor(.primary)
							Spacer()
							Image(systemName: "chevron.right")
								.font(.caption)
								.foregroundColor(.secondary)
						}
					}
				}
			} header: {
				Text("Sub Items")
			}

			Section {
				Button("Pop to Root") {
					router.popToRoot()
				}
				.foregroundColor(.red)
			}
		}
		.navigationTitle("Detail \(id)")
		.navigationBarTitleDisplayMode(.large)
	}
}

struct NestedDetailView: View {
	let id: Int
	let subId: Int
	let router: Router<HomeRoute>

	var body: some View {
		VStack(spacing: 20) {
			Image(systemName: "doc.richtext.fill")
				.font(.system(size: 60))
				.foregroundColor(.green)

			Text("Nested Detail")
				.font(.title)
				.fontWeight(.bold)

			Text("Item: \(id) | Sub-item: \(subId)")
				.font(.headline)
				.foregroundColor(.secondary)

			VStack(spacing: 12) {
				Button {
					router.pop()
				} label: {
					Label("Go Back", systemImage: "chevron.left")
						.frame(maxWidth: .infinity)
				}
				.buttonStyle(.bordered)

				Button {
					router.popToRoot()
				} label: {
					Label("Back to Home", systemImage: "house")
						.frame(maxWidth: .infinity)
				}
				.buttonStyle(.borderedProminent)

				if router.contains(.detail(id: id)) {
					Button {
						router.popTo(.detail(id: id))
					} label: {
						Label("Back to Detail \(id)", systemImage: "arrow.uturn.left")
							.frame(maxWidth: .infinity)
					}
					.buttonStyle(.bordered)
					.tint(.orange)
				}
			}
			.padding()

			Spacer()

			Text("Stack Depth: \(router.depth)")
				.font(.caption)
				.foregroundColor(.secondary)
		}
		.padding()
		.navigationTitle("Nested Detail")
		.navigationBarTitleDisplayMode(.inline)
	}
}

// MARK: - Settings Tab Views

struct SettingsTabView: View {
	let router: Router<SettingsRoute>

	var body: some View {
		List {
			Section {
				Button {
					router.push(.profile(userId: "user123"))
				} label: {
					HStack {
						Image(systemName: "person.circle.fill")
							.font(.title2)
							.foregroundColor(.blue)
						VStack(alignment: .leading) {
							Text("John Doe")
								.fontWeight(.semibold)
							Text("View Profile")
								.font(.caption)
								.foregroundColor(.secondary)
						}
						Spacer()
						Image(systemName: "chevron.right")
							.font(.caption)
							.foregroundColor(.secondary)
					}
				}
			}

			Section {
				Button {
					router.push(.notifications)
				} label: {
					HStack {
						Label("Notifications", systemImage: "bell.fill")
							.foregroundColor(.primary)
						Spacer()
						Image(systemName: "chevron.right")
							.font(.caption)
							.foregroundColor(.secondary)
					}
				}

				NavigationLink("Appearance") {
					Text("Appearance Settings")
				}

				NavigationLink("Privacy") {
					Text("Privacy Settings")
				}
			} header: {
				Text("Preferences")
			}

			Section {
				NavigationLink("About") {
					Text("About App")
				}

				NavigationLink("Help") {
					Text("Help & Support")
				}
			}
		}
		.navigationTitle("Settings")
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Text("Stack: \(router.depth)")
					.font(.caption)
					.foregroundColor(.secondary)
			}
		}
	}
}

struct ProfileView: View {
	let userId: String
	let router: Router<SettingsRoute>

	var body: some View {
		List {
			Section {
				HStack {
					Image(systemName: "person.crop.circle.fill")
						.font(.system(size: 60))
						.foregroundColor(.blue)

					VStack(alignment: .leading, spacing: 4) {
						Text("John Doe")
							.font(.title2)
							.fontWeight(.bold)
						Text("@johndoe")
							.foregroundColor(.secondary)
						Text("ID: \(userId)")
							.font(.caption)
							.foregroundColor(.secondary)
					}
				}
				.padding(.vertical)
			}

			Section {
				Button {
					router.push(.editProfile(userId: userId))
				} label: {
					Label("Edit Profile", systemImage: "pencil")
						.foregroundColor(.primary)
				}
			}

			Section {
				LabeledContent("Email", value: "john@example.com")
				LabeledContent("Phone", value: "+1 234 567 8900")
				LabeledContent("Location", value: "San Francisco, CA")
			} header: {
				Text("Contact Information")
			}

			Section {
				Button("Pop to Settings") {
					router.popToRoot()
				}
				.foregroundColor(.blue)
			}
		}
		.navigationTitle("Profile")
		.navigationBarTitleDisplayMode(.inline)
	}
}

struct EditProfileView: View {
	let userId: String
	let router: Router<SettingsRoute>
	@State private var name = "John Doe"
	@State private var email = "john@example.com"
	@State private var bio = "iOS Developer"

	var body: some View {
		Form {
			Section {
				TextField("Name", text: $name)
				TextField("Email", text: $email)
					.keyboardType(.emailAddress)
					.textInputAutocapitalization(.never)
			} header: {
				Text("Basic Information")
			}

			Section {
				TextField("Bio", text: $bio, axis: .vertical)
					.lineLimit(3...6)
			} header: {
				Text("About")
			}

			Section {
				Button("Save Changes") {
					router.pop()
				}
				.frame(maxWidth: .infinity)
				.foregroundColor(.white)
				.listRowBackground(Color.blue)

				Button("Cancel") {
					router.pop()
				}
				.frame(maxWidth: .infinity)
			}
		}
		.navigationTitle("Edit Profile")
		.navigationBarTitleDisplayMode(.inline)
	}
}

struct NotificationsView: View {
	let router: Router<SettingsRoute>
	@State private var pushEnabled = true
	@State private var emailEnabled = false
	@State private var soundEnabled = true

	var body: some View {
		Form {
			Section {
				Toggle("Push Notifications", isOn: $pushEnabled)
				Toggle("Email Notifications", isOn: $emailEnabled)
				Toggle("Sound", isOn: $soundEnabled)
			} header: {
				Text("Notification Settings")
			}

			Section {
				Button("Reset to Defaults") {
					pushEnabled = true
					emailEnabled = false
					soundEnabled = true
				}
			}
		}
		.navigationTitle("Notifications")
	}
}

// MARK: - Preview
#Preview {
	DashboardView()
}
