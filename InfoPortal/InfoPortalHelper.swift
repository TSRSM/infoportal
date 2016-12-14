//
//  InfoPortalHelper.swift
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
}

extension InfoPortalError {
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

//enum InfoPortalResponse<T> {
//	case error(Error)
//	case success(T)
//}

typealias Handler<T> = ((T) -> ())?

class InfoPortalHelper {
	
	static let shared = InfoPortalHelper()
	private init() {}
	
	let keychain = Keychain(service: "org.tsrs.InfoPortal.session").synchronizable(true)
	
	var session: String? {
		get { return keychain["user"] }
		set { keychain["user"] = newValue }
	}
	
	func request(endpoint: String, parameters: Parameters = [:], requiresAuth: Bool = true, method: HTTPMethod = .post, errorMessage: String, error: Handler<Error>, success: ((JSON) -> ())?) {
		var parameters = parameters
		if requiresAuth {
			guard let session = session else {
				error?(InfoPortalError.invalidSession)
				return
			}
			parameters["session_id"] = session
		}
		Alamofire.request("http://infoportal.tsrs.org/api/\(endpoint)", method: method, parameters: parameters).validate().responseJSON { response in
			switch response.result {
			case .failure(let err):
				error?(err)
			case .success(let value):
				let json = JSON(value)
				if let err = json["error"].string {
					error?(InfoPortalError.endpointError("\(errorMessage): \(err)"))
				} else if json["status"].string == "error" {
					error?(InfoPortalError.endpointError(errorMessage))
				} else {
					success?(json)
				}
			}
		}
	}
	
	// MARK: - Endpoints
	
	func login(username: String, password: String, error: Handler<Error>, success: Handler<String>) {
		let parameters = ["username": username, "password": password]
		request(endpoint: "login", parameters: parameters, requiresAuth: false, errorMessage: "Failed to login", error: error) { json in
			guard let session = json["session_id"].string else {
				error?(InfoPortalError.invalidSession)
				return
			}
			self.session = session
			success?(session)
		}
	}
	
	func logout(error: Handler<Error>, success: Handler<Void>) {
		request(endpoint: "logout", errorMessage: "Failed to logout", error: error) { _ in
			self.session = nil
			success?()
		}
	}
	
	func updates(filter: [String], error: Handler<Error>, success: Handler<[Update]>) {
		request(endpoint: "updates", parameters: ["filter": filter], errorMessage: "Failed to fetch updates", error: error) { json in
			guard let array = json.array else {
				error?(InfoPortalError.invalidJSON)
				return
			}
			let updates: [Update] = array.flatMap { update in
				guard let rawPostID = update["id"].string,
					let postID = Int(rawPostID),
					let rawAuthorID = update["author_id"].string,
					let authorID = Int(rawAuthorID),
					let target = update["target"].string,
					let title = update["title"].string,
					let content = update["content"].string,
					let targetName = update["target_name"].string
					else { return nil }
				return Update(postID: postID, authorID: authorID, target: target, title: title, content: content, targetName: targetName)
			}
			success?(updates)
		}
	}
	
	func post(content: String, title: String, type: String, error: Handler<Error>, success: Handler<Void>) {
		let parameters = ["content": content, "title": title, "type": type]
		request(endpoint: "post", parameters: parameters, errorMessage: "Failed to post", error: error) { _ in success?() }
	}
	
	func profile(error: Handler<Error>, success: Handler<Profile>) {
		request(endpoint: "prof", errorMessage: "Failed to fetch profile", error: error) { json in
			guard let house = json["house"].string,
				let name = json["name"].string,
				let schoolClass = json["class"].string,
				let email = json["email"].string
				else {
					error?(InfoPortalError.invalidJSON)
					return
			}
			success?(Profile(name: name, schoolClass: schoolClass, house: house, email: email))
		}
	}
	
	func identifiers(error: Handler<Error>, success: Handler<[Identifier]>) {
		request(endpoint: "identifiers", requiresAuth: false, method: .get, errorMessage: "Failed to fetch identifiers", error: error) { json in
			guard let array = json.array else {
				error?(InfoPortalError.invalidJSON)
				return
			}
			let identifiers: [Identifier] = array.flatMap { identifier in
				guard let type = identifier["type"].string,
					let title = identifier["title"].string,
					let ref = identifier["ref"].string,
					let description = identifier["description"].string
					else { return nil }
				return Identifier(type: type, title: title, ref: ref, description: description)
			}
			success?(identifiers)
		}
	}
	
}

extension UIViewController {
	
	func present(error: Error,
	             title: String = "Error",
	             animated: Bool = true,
	             additionalActions: [UIAlertAction]? = nil,
	             completion: (() -> Void)? = nil) {
		present(title: title, message: error.localizedDescription)
	}
	
	func present(title: String,
	             message: String,
	             animated: Bool = true,
	             additionalActions: [UIAlertAction]? = nil,
	             completion: (() -> Void)? = nil) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .cancel)
		alertController.addAction(okAction)
		additionalActions?.forEach {alertController.addAction($0)}
		present(alertController, animated: animated, completion: completion)
	}
	
}
