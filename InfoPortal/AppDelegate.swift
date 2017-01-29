//
//  AppDelegate.swift
//  InfoPortal
//
//  Created by Kabir Oberai on 11/12/16.
//  Copyright © 2016 Kabir Oberai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		let backgroundView = UIImageView(image: #imageLiteral(resourceName: "gaussiantsrs"))
		backgroundView.contentMode = .scaleAspectFill
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
		window?.addSubview(backgroundView)
		NSLayoutConstraint.activate([
			backgroundView.topAnchor.constraint(equalTo: window!.topAnchor),
			backgroundView.bottomAnchor.constraint(equalTo: window!.bottomAnchor),
			backgroundView.leftAnchor.constraint(equalTo: window!.leftAnchor),
			backgroundView.rightAnchor.constraint(equalTo: window!.rightAnchor)
		])
		
		return true
	}

}
