//
//  LoginViewController.swift
//  InfoPortal
//
//  Created by Kabir Oberai on 11/12/16.
//  Copyright © 2016 Kabir Oberai. All rights reserved.
//

import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
	
	@IBOutlet weak var loginLabel: UILabel!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet var stackViewCenter: NSLayoutConstraint!
	@IBOutlet weak var buttonStackView: UIStackView!
	@IBOutlet var textFields: [UITextField]!
	
	let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
	
	var loggingIn = false
	
	var canSubmit: Bool {
		guard let username = usernameTextField.text, let password = passwordTextField.text else {return false}
		return !loggingIn && !username.isEmpty && !password.isEmpty
	}
	
	@IBAction func updateSubmitButton() {
		submitButton.isEnabled = canSubmit
		submitButton.alpha = canSubmit ? 1 : 0.75
	}
	
	@IBAction func submitTapped() {
		guard canSubmit else { return }
		beginLogin()
		// TODO: Implement logging in
	}
	
	// MARK: - View controller lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		stackView.arrangedSubviews.forEach { $0.alpha = 0 }
		submitButton.isEnabled = false
		textFields.forEach {
			$0.delegate = self
			$0.backgroundColor = UIColor(white: 1, alpha: 0.75)
		}
		activityIndicator.startAnimating()
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateSubmitButton()
		for (i, element) in stackView.arrangedSubviews.enumerated() {
			element.isUserInteractionEnabled = false
			UIView.animate(withDuration: 1, delay: Double(i) * 0.1, animations: {
				element.alpha = 1
			}, completion: { _ in
				element.isUserInteractionEnabled = true
			})
		}
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	// MARK: - Event listeners
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		view.endEditing(true)
	}
	
	func keyboardWillShow(notification: Notification) {
		animateViews(up: true, with: notification)
	}
	
	func keyboardWillHide(notification: Notification) {
		animateViews(up: false, with: notification)
	}
	
	// MARK: - Helper functions
	
	func animateViews(up: Bool, with notification: Notification) {
		guard let beginFrame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue,
			let endFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue,
			let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
			beginFrame != endFrame
			else { return }
		UIView.animate(withDuration: TimeInterval(duration)) {
			self.stackViewCenter.isActive = !up // If inactive, the lower priority -100 constraint activates
			self.view.layoutIfNeeded()
		}
	}
	
	func beginLogin() {
		view.endEditing(true)
		loggingIn = true
		updateSubmitButton()
		textFields.forEach { $0.alpha = 0.2 }
		buttonStackView.addArrangedSubview(activityIndicator)
//		UIView.transition(with: loginLabel, duration: 0.5, options: [.transitionFlipFromRight], animations: {
//			self.loginLabel.text = "Logging in"
//		})
	}
	
	func endLogin() {
		loggingIn = false
		updateSubmitButton()
		textFields.forEach { $0.alpha = 1 }
		buttonStackView.removeArrangedSubview(activityIndicator)
//		UIView.transition(with: loginLabel, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
//			self.loginLabel.text = "Log in"
//		})
	}
	
}

extension LoginViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == usernameTextField {
			passwordTextField.becomeFirstResponder()
		} else {
			submitTapped()
		}
		return true
	}
	
}
