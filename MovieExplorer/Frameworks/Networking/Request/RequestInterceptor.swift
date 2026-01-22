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
			print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
			print("📡 Request: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
			
			if let headers = request.allHTTPHeaderFields, logLevel == .verbose {
				print("📋 Headers: \(headers)")
			}
			
			if let body = request.httpBody, logLevel == .verbose {
				print("📦 Body: \(String(data: body, encoding: .utf8) ?? "")")
			}
			
			if let response = response {
				print("✅ Response: \(response.statusCode)")
			}
			
			if let error = error {
				print("❌ Error: \(error.localizedDescription)")
			}
			
			print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
		}
	}
}
