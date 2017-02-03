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
	let title: String
	let content: String
	let timestamp: Date?
	
	let authorID: String
	let author: String
	
	let target: String
	let targetName: String
	
	let color: String
	
	init?(json: JSON) {
		guard let rawPostID = json["id"].string,
			let postID = Int(rawPostID),
			let authorID = json["author_id"].string,
			let author = json["author"].string,
			let target = json["target"].string,
			let title = json["title"].string,
			let content = json["content"].string,
			let targetName = json["target_name"].string,
			let color = json["colour"].string,
			let timestamp = json["timestamp"].string
			else { return nil }
		self.postID = postID
		self.authorID = authorID
		self.author = author
		self.target = target
		self.title = title
		self.content = content
		self.targetName = targetName
		self.color = color
		
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		formatter.timeZone = TimeZone(abbreviation: "IST")
		self.timestamp = formatter.date(from: timestamp)
	}
	
}
