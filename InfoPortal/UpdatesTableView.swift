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
	
	override func prepareForInterfaceBuilder() { // Only shows up in IB
		let bundle = Bundle(for: type(of: self))
		let image = UIImage(named: "gaussiantsrs", in: bundle, compatibleWith: nil)
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFill
		backgroundView = imageView
	}
	
}
