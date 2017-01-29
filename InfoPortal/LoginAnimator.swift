//
//  LoginAnimator.swift
//  InfoPortal
//
//  Created by Kabir Oberai on 28/01/17.
//  Copyright © 2017 Kabir Oberai. All rights reserved.
//

import UIKit

class LoginAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	
	var isAppearing: Bool
	
	init(isAppearing: Bool) {
		self.isAppearing = isAppearing
	}
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 1
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let duration = transitionDuration(using: transitionContext)
		let container = transitionContext.containerView
		let toVC = transitionContext.viewController(forKey: .to)!
		let fromVC = transitionContext.viewController(forKey: .from)!
		
		let navVC = (isAppearing ? toVC : fromVC) as! UINavigationController
		let updatesVC = navVC.topViewController as! UpdatesViewController
		let loginVC = (isAppearing ? fromVC : toVC) as! LoginViewController
		
		container.addSubview(toVC.view)
		
		navVC.isNavigationBarHidden = isAppearing
		let updatesHeight = updatesVC.view.frame.height
		if isAppearing {
			updatesVC.tableView.frame.origin.y = updatesHeight
		} else {
			loginVC.stackView.alpha = 0
		}
		
		UIView.animate(withDuration: duration / 4) {
			loginVC.stackView.alpha = self.isAppearing ? 0 : 1
		}
		
		UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, animations: {
			if self.isAppearing {
				updatesVC.tableView.frame.origin.y = 0
				navVC.isNavigationBarHidden = !self.isAppearing
			} else {
				navVC.view.frame.origin.y = updatesHeight + 64
			}
		}, completion: { _ in
			if self.isAppearing {
				loginVC.usernameTextField.text = ""
				loginVC.passwordTextField.text = ""
				loginVC.updateSubmitButton()
			} else {
				loginVC.stackView.alpha = 1
			}
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		})
		
	}
	
}
