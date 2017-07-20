//
//  Update.swift
//  InfoPortal
//
//  Created by Kabir Oberai on 13/12/16.
//  Copyright © 2016 Kabir Oberai. All rights reserved.
//

import SwiftyJSON

class Update { // Class because of lazy properties
	
	let postID: Int
	let title: String
	let content: String
	
	static var htmlFormatting: String? = {
		guard let path = Bundle.main.path(forResource: "stylesheet", ofType: "css"),
			let stylesheet = try? String(contentsOfFile: path)
			else { return nil }
		return "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><style>\(stylesheet)</style>"
	}()
	
	lazy var attributedContent: NSAttributedString? = {
		guard let formatting = Update.htmlFormatting else { return nil }
		let html = formatting + content
		return html.htmlAttributed
	}()
	
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
		self.targetName = targetName
		self.color = color.isEmpty ? "#333333" : color
		print(self.color)
		self.content = content
		
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		formatter.timeZone = TimeZone(abbreviation: "IST")
		self.timestamp = formatter.date(from: timestamp)
	}
	
}
