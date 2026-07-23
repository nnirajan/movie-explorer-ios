//
//  Parameter.swift
//  MovieExplorer
//
//  Created by Nirajan Shrestha on 22/01/2026.
//

import Foundation

public typealias Parameters = [String: Any]

// MARK: - Parameters Extension
extension Parameters {
	func percentEncoded(parentKey: String? = nil) -> String {
		map { key, value in
			var escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .allowedQueryCharacterSet) ?? ""
			if let parentKey = parentKey {
				escapedKey = "\(parentKey)[\(escapedKey)]"
			}
			
			if let dict = value as? Parameters {
				return dict.percentEncoded(parentKey: escapedKey)
			} else if let array = value as? [CustomStringConvertible] {
				return array.map { entry in
					let escapedValue = "\(entry)".addingPercentEncoding(withAllowedCharacters: .allowedQueryCharacterSet) ?? ""
					return "\(escapedKey)[]=\(escapedValue)"
				}.joined(separator: "&")
			} else {
				let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .allowedQueryCharacterSet) ?? ""
				return "\(escapedKey)=\(escapedValue)"
			}
		}.joined(separator: "&")
	}
}

// MARK: - CharacterSet Extension
extension CharacterSet {
	static let allowedQueryCharacterSet: CharacterSet = {
		let generalDelimitersToEncode = ":#[]@"
		let subDelimitersToEncode = "!$&'()*+,;="
		var allowed = CharacterSet.urlQueryAllowed
		allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
		return allowed
	}()
}
