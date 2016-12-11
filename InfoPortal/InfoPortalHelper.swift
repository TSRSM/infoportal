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
	case endpointError(String)
}

extension InfoPortalError {
	var errorDescription: String? {
		switch self {
		case .invalidSession:
			return "Invalid session"
		case .endpointError(let message):
			return message
		}
	}
}

enum InfoPortalEndpoint: String {
	case login = "login"
	case logout = "logout"
	case updates = "updates"
	case post = "post"
	case profile = "prof"
	case identifiers = "identifiers"
}

typealias ErrorHandler = (Error) -> ()
typealias SuccessHandler = (JSON) -> ()

class InfoPortalHelper {
	
	static let shared = InfoPortalHelper()
	private init() {}
	
	let keychain = Keychain(service: "org.tsrs.infoportal.session").synchronizable(true)
	
	var session: String? {
		get {
			return keychain["user"]
		}
		set {
			keychain["user"] = newValue
		}
	}
	
	func request(endpoint: InfoPortalEndpoint, parameters: Parameters = [:], requiresAuth: Bool = true, method: HTTPMethod = .post, errorMessage: String, error: ErrorHandler?, success: SuccessHandler?) {
		var parameters = parameters
		if requiresAuth {
			guard let session = session else {
				error?(InfoPortalError.invalidSession)
				return
			}
			parameters["session_id"] = session
		}
		Alamofire.request("http://infoportal.tsrs.org/api/\(endpoint.rawValue)", method: method, parameters: parameters).validate().responseJSON { response in
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
	
	func login(username: String, password: String, error: ErrorHandler?, success: SuccessHandler?) {
		let parameters = ["username": username, "password": password]
		request(endpoint: .login, parameters: parameters, requiresAuth: false, errorMessage: "Failed to login", error: error) { json in
			self.session = json["session_id"].string
			success?(json)
		}
	}
	
	func logout(error: ErrorHandler?, success: SuccessHandler?) {
		request(endpoint: .logout, errorMessage: "Failed to logout", error: error, success: success)
		self.session = nil
	}
	
	func updates(filter: [String], error: ErrorHandler?, success: SuccessHandler?) {
		request(endpoint: .updates, parameters: ["filter": filter], errorMessage: "Failed to update", error: error, success: success)
	}
	
	func post(content: String, title: String, type: String, audience: [Int], error: ErrorHandler?, success: SuccessHandler?) {
		// TODO: Test this out, and confirm whether audience does anything
		let parameters: [String: Any] = ["content": content, "title": title, "type": type, "audience": audience]
		request(endpoint: .post, parameters: parameters, errorMessage: "Failed to post", error: error, success: success)
	}
	
	func profile(error: ErrorHandler?, success: SuccessHandler?) {
		request(endpoint: .profile, errorMessage: "Failed to fetch profile", error: error, success: success)
	}
	
	func identifiers(error: ErrorHandler?, success: SuccessHandler?) {
		request(endpoint: .identifiers, requiresAuth: false, method: .get, errorMessage: "Failed to fetch identifiers", error: error, success: success)
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
