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
	
	let kSubmitDisabledAlpha: CGFloat = 0.75
	let kTextFieldDisabledAlpha: CGFloat = 0.2
	let kLoginLabelDisabledAlpha: CGFloat = 0.2
	
	let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
	var loggingIn = false
	
	var canSubmit: Bool {
		return !loggingIn && usernameTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false
	}
	
	@IBAction func updateSubmitButton() {
		submitButton.isEnabled = canSubmit
		submitButton.alpha = canSubmit ? 1 : kSubmitDisabledAlpha
	}
	
	@IBAction func submitTapped() {
		guard canSubmit else { return }
		animateLogin(begin: true)
		Helper.login(username: usernameTextField.text!, password: passwordTextField.text!, error: { error in
			self.animateLogin(begin: false)
			self.present(error: error)
		}, success: { session in
			self.animateLogin(begin: false)
			self.present(title: "Success!", message: session)
		})
	}
	
	// MARK: - View controller lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateSubmitButton()
		activityIndicator.startAnimating()
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
	
	// MARK: - Event listeners
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		view.endEditing(true)
	}
	
	func keyboardWillShow(notification: Notification) {
		animateStackView(up: true, with: notification)
	}
	
	func keyboardWillHide(notification: Notification) {
		animateStackView(up: false, with: notification)
	}
	
	// MARK: - Helper functions
	
	func animateStackView(up: Bool, with notification: Notification) {
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
	
	func animateLogin(begin: Bool) {
		view.endEditing(true)
		loggingIn = begin
		updateSubmitButton()
		[usernameTextField, passwordTextField].forEach {
			$0?.alpha = begin ? kTextFieldDisabledAlpha : 1
			$0?.isUserInteractionEnabled = !begin
		}
		loginLabel.alpha = begin ? kLoginLabelDisabledAlpha : 1
		if begin {
			buttonStackView.addArrangedSubview(activityIndicator)
		} else {
			buttonStackView.removeArrangedSubview(activityIndicator)
			activityIndicator.removeFromSuperview()
		}
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
