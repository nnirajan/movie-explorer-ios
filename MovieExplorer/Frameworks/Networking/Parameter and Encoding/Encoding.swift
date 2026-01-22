//
//  Encoding.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import Foundation

public enum EncoderType {
	case json(Parameters?)
	case url(Parameters?)
}

// MARK: - URLRequest Encoding Extensions
extension URLRequest {
	mutating func jsonEncoding(_ parameters: Parameters?) throws {
		guard let params = parameters else { return }
		do {
			httpBody = try JSONSerialization.data(withJSONObject: params, options: .sortedKeys)
			setValue("application/json", forHTTPHeaderField: "Content-Type")
		} catch {
			throw NetworkError.encodingError(error)
		}
	}
	
	mutating func urlEncoding(_ parameters: Parameters?) throws {
		guard let params = parameters else { return }
		
		if let method = httpMethod, supportsURLQuery(method: method), let requestURL = url {
			var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
			var queryItems = urlComponents?.queryItems ?? []
			
			params.forEach { key, value in
				if let array = value as? [CustomStringConvertible] {
					array.forEach {
						queryItems.append(URLQueryItem(name: "\(key)[]", value: "\($0)"))
					}
				} else {
					queryItems.append(URLQueryItem(name: key, value: "\(value)"))
				}
			}
			
			urlComponents?.queryItems = queryItems
			url = urlComponents?.url
		} else {
			httpBody = params.percentEncoded().data(using: .utf8)
			setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		}
	}
	
	private func supportsURLQuery(method: String) -> Bool {
		[HTTPMethod.get.identifier, HTTPMethod.delete.identifier].contains(method)
	}
}
