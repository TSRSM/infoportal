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
		let updatesTableView = updatesVC.tableView as! UpdatesTableView
		if isAppearing {
			updatesTableView.frame.origin.y = updatesHeight
			updatesTableView.bgGradient.opacity = 0
		} else {
			loginVC.stackView.alpha = 0
		}
		
		let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.opacity))
		opacityAnimation.fromValue = isAppearing ? 0 : 1
		opacityAnimation.toValue = isAppearing ? 1 : 0
		opacityAnimation.duration = duration
		updatesTableView.bgGradient.add(opacityAnimation, forKey: "opacityAnimation")
		updatesTableView.bgGradient.opacity = isAppearing ? 1 : 0
		
		if !isAppearing {
			loginVC.stackView.alpha = 1
		}
		
		UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, animations: {
			if self.isAppearing {
				updatesTableView.frame.origin.y = 0
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
