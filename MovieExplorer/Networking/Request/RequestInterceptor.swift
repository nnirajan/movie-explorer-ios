//
//  RequestInterceptor.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import Foundation

// MARK: - Request Interceptor Protocol
protocol RequestInterceptor {
	func intercept(_ request: URLRequest, response: HTTPURLResponse?, data: Data?, error: Error?) async throws
}

// MARK: - Logging Interceptor
final class LoggingInterceptor: RequestInterceptor {
	enum LogLevel {
		case verbose
		case info
		case error
	}
	
	private let logLevel: LogLevel
	
	init(logLevel: LogLevel = .info) {
		self.logLevel = logLevel
	}
	
	func intercept(_ request: URLRequest, response: HTTPURLResponse?, data: Data?, error: Error?) async throws {
		if logLevel == .verbose || (logLevel == .info && error == nil) || (logLevel == .error && error != nil) {
			print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
			print("📡 Request: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
			
			if let headers = request.allHTTPHeaderFields, logLevel == .verbose {
				var sanitizedHeaders = headers
				if sanitizedHeaders["Authorization"] != nil {
					sanitizedHeaders["Authorization"] = "Bearer ***"
				}
				
				let formattedHeaders = sanitizedHeaders
					.sorted(by: { $0.key < $1.key })
					.map { "\"\($0.key)\": \"\($0.value)\"" }
					.joined(separator: ", ")
				
				print("📋 Headers: [\(formattedHeaders)]")
			}
			
			if let body = request.httpBody, logLevel == .verbose {
				print("📦 Body: \(String(data: body, encoding: .utf8) ?? "")")
			}
			
			if let response = response {
				print("✅ Response: \(response.statusCode)")
				
				if let data = data, logLevel == .verbose {
					if let jsonObject = try? JSONSerialization.jsonObject(with: data),
					   let prettyData = try? JSONSerialization.data(
						withJSONObject: jsonObject,
						options: [.prettyPrinted, .sortedKeys]
					   ),
					   let prettyString = String(data: prettyData, encoding: .utf8) {
						print("📥 Response Data:\n\(prettyString)")
					} else {
						print("📥 Response Data: \(String(data: data, encoding: .utf8) ?? "")")
					}
				}
			}
			
			if let error = error {
				print("❌ Error: \(error.localizedDescription)")
			}			
		}
	}
}

// MARK: - Analytics Interceptor
final class AnalyticsInterceptor: RequestInterceptor {
	func intercept(_ request: URLRequest, response: HTTPURLResponse?, data: Data?, error: Error?) async throws {
		// Track API calls for analytics
		if let error = error {
			// Log error to analytics service
			print("📊 Analytics: API Error - \(request.url?.path ?? "")")
		} else if let statusCode = response?.statusCode {
			// Log successful request
			print("📊 Analytics: API Success - \(request.url?.path ?? "") - \(statusCode)")
		}
	}
}
