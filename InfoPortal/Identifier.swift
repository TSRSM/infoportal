//
//  Identifier.swift
//  InfoPortal
//
//  Created by Kabir Oberai on 13/12/16.
//  Copyright © 2016 Kabir Oberai. All rights reserved.
//

import SwiftyJSON

struct Identifier {
	
	let type: String
	let title: String
	let ref: String
	let description: String
	
	init?(json: JSON) {
		guard let type = json["type"].string,
			let title = json["title"].string,
			let ref = json["ref"].string,
			let description = json["description"].string
			else { return nil }
		self.type = type
		self.title = title
		self.ref = ref
		self.description = description
	}
	
}
