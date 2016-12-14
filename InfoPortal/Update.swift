//
//  Update.swift
//  InfoPortal
//
//  Created by Kabir Oberai on 13/12/16.
//  Copyright © 2016 Kabir Oberai. All rights reserved.
//

import SwiftyJSON

struct Update {
	
	let postID: Int
	let authorID: Int
	let target: String
	let title: String
	let content: String
	let targetName: String
	
	init?(json: JSON) {
		guard let rawPostID = json["id"].string,
			let postID = Int(rawPostID),
			let rawAuthorID = json["author_id"].string,
			let authorID = Int(rawAuthorID),
			let target = json["target"].string,
			let title = json["title"].string,
			let content = json["content"].string,
			let targetName = json["target_name"].string
			else { return nil }
		self.postID = postID
		self.authorID = authorID
		self.target = target
		self.title = title
		self.content = content
		self.targetName = targetName
	}
	
}
