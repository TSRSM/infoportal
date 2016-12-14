//
//  Profile.swift
//  InfoPortal
//
//  Created by Kabir Oberai on 13/12/16.
//  Copyright © 2016 Kabir Oberai. All rights reserved.
//

import SwiftyJSON

struct Profile {
	
	let name: String
	let	schoolClass: String
	let house: String
	let email: String
	
	init?(json: JSON) {
		guard let house = json["house"].string,
			let name = json["name"].string,
			let schoolClass = json["class"].string,
			let email = json["email"].string
			else { return nil }
		self.name = name
		self.schoolClass = schoolClass
		self.house = house
		self.email = email
	}
	
}
