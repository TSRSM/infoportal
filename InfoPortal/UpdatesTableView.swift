//
//  UpdatesTableView.swift
//  InfoPortal
//
//  Created by Kabir Oberai on 29/01/17.
//  Copyright © 2017 Kabir Oberai. All rights reserved.
//

import UIKit

@IBDesignable
class UpdatesTableView: UITableView {
	
	let bgGradient = CAGradientLayer()
	
	override func awakeFromNib() {
		setupBackground()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		positionBackground()
	}
	
	override func prepareForInterfaceBuilder() {
		super.layoutSubviews()
		setupBackground()
		positionBackground()
	}
	
	func setupBackground() {
		bgGradient.colors = [#colorLiteral(red: 0.73485291, green: 0.1408088207, blue: 0.1749014854, alpha: 1).cgColor, UIColor.black.cgColor]
		bgGradient.startPoint = CGPoint(x: 0, y: 0.5)
		bgGradient.endPoint = CGPoint(x: 1, y: 0.5)
		superview?.layer.insertSublayer(bgGradient, at: 0)
	}
	
	func positionBackground() {
		bgGradient.frame = frame
		bgGradient.frame.origin.y -= 64
		bgGradient.frame.size.height += 64
	}
	
}
