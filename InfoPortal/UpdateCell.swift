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
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var topBar: UIView!
	@IBOutlet weak var contentTextView: UITextView!
	@IBOutlet weak var colorBar: UIView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		topBar.layer.shadowOpacity = 1
    }

}
