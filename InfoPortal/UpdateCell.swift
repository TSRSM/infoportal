//
//  UpdateCell.swift
//  InfoPortal
//
//  Created by Kabir Oberai on 29/01/17.
//  Copyright © 2017 Kabir Oberai. All rights reserved.
//

import UIKit

@IBDesignable
class UpdateCell: UITableViewCell {
	
	@IBOutlet weak var body: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var targetLabel: UILabel!
	@IBOutlet weak var topBar: UIView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		body.layer.cornerRadius = 10
    }
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		// Animated always seems to be false
		// TODO: Expand cell to reveal info (add relevant WKWebView programatically)
	}

}
