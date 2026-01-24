//
//  NetworkRequest.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 21/01/2026.
//

import Foundation

public typealias HTTPHeaders = [String: String]

protocol NetworkRequest {
	/// The endpoint path that will get appended to base path
	var path: String { get }
	
	/// The requests method
	var method: HTTPMethod { get }
	
	/// The headers that will be passed by client to the request
	var headers: HTTPHeaders? { get }
	
	/// The encoders to use to be used for parameter encoding
	var encoders: [EncoderType] { get }
	
	/// The base URL to override if need be
	var overridenBaseURL: String? { get }
	
	var timeoutInterval: TimeInterval { get }
}

/// Deafult implementations
extension NetworkRequest {
	var headers: HTTPHeaders? { nil }
	var overridenBaseURL: String? { nil }
	var timeoutInterval: TimeInterval { 60 }
}
