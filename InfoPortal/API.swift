//
//  API.swift
//  InfoPortal
//
//  Created by Kabir Oberai on 11/12/16.
//  Copyright © 2016 Kabir Oberai. All rights reserved.
//

import Alamofire
import SwiftyJSON
import KeychainAccess

enum InfoPortalError: LocalizedError {
	
	case invalidSession
	case invalidJSON
	case endpointError(String)
	
	var errorDescription: String? {
		switch self {
		case .invalidSession:
			return "Invalid session"
		case .invalidJSON:
			return "Invalid JSON"
		case .endpointError(let message):
			return message
		}
	}
	
}

struct API {
	
	private init() {}
	private static let keychain = Keychain(service: "org.tsrs.InfoPortal.session").synchronizable(true)
	private static var session: String? {
		get { return keychain["user"] }
		set { keychain["user"] = newValue }
	}
	
	static var isLoggedIn: Bool { return session != nil }
	
	typealias Handler<T> = ((T) -> ())?
	
	private static func request(endpoint: String, parameters: Parameters = [:], requiresAuth: Bool = true, method: HTTPMethod = .post, error: Handler<Error>, success: Handler<JSON>) {
		var parameters = parameters
		if requiresAuth {
			guard let session = session else {
				error?(InfoPortalError.invalidSession)
				return
			}
			parameters["session_id"] = session
		}
		let url = "http://infoportal.tsrs.org/api/\(endpoint)"
		Alamofire.request(url, method: method, parameters: parameters).validate().responseJSON { response in
			switch response.result {
			case .failure(let err):
				error?(err)
			case .success(let value):
				let json = JSON(value)
				if let err = json["error"].string {
					error?(InfoPortalError.endpointError(err))
				} else if json["status"].string == "error" {
					error?(InfoPortalError.endpointError("Error at \(url)"))
				} else {
					success?(json)
				}
			}
		}
	}
	
	// MARK: - Endpoints
	
	static func login(username: String, password: String, error: Handler<Error>, success: Handler<Void>) {
		let parameters = ["username": username, "password": password]
		request(endpoint: "login", parameters: parameters, requiresAuth: false, error: error) { json in
			guard let session = json["session_id"].string else {
				error?(InfoPortalError.invalidSession)
				return
			}
			self.session = session
			success?()
		}
	}
	
	static func logout(error: Handler<Error>, success: Handler<Void>) {
		request(endpoint: "logout", error: error, success: { _ in success?() })
		self.session = nil
	}
	
	static func updates(filter: [String], error: Handler<Error>, success: Handler<[Update]>) {
		request(endpoint: "updates", parameters: ["filter": filter], error: error) { json in
			guard let array = json.array else {
				error?(InfoPortalError.invalidJSON)
				return
			}
			success?(array.flatMap { Update(json: $0) })
		}
	}
	
	static func post(title: String, content: String, ref: String, error: Handler<Error>, success: Handler<Void>) {
		let parameters = ["content": content, "title": title, "target": ref]
		request(endpoint: "post", parameters: parameters, error: error) { _ in success?() }
	}
	
	static func profile(error: Handler<Error>, success: Handler<Profile>) {
		request(endpoint: "prof", error: error) { json in
			guard let profile = Profile(json: json) else {
				error?(InfoPortalError.invalidJSON)
				return
			}
			success?(profile)
		}
	}
	
	static func identifiers(error: Handler<Error>, success: Handler<[Identifier]>) {
		request(endpoint: "identifiers", requiresAuth: false, method: .get, error: error) { json in
			guard let array = json.array else {
				error?(InfoPortalError.invalidJSON)
				return
			}
			success?(array.flatMap { Identifier(json: $0) })
		}
	}
	
}
