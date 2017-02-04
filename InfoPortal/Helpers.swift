//
//  Helpers.swift
//  InfoPortal
//
//  Created by Kabir Oberai on 04/02/17.
//  Copyright © 2017 Kabir Oberai. All rights reserved.
//

import UIKit

protocol IdentifierManagerDelegate {
	func identifiersDidChange()
}

class IdentifierManager {
	
	static let shared = IdentifierManager()
	private init() {}
	
	var delegate: IdentifierManagerDelegate?
	
	var identifiers: [Identifier] = [] {
		didSet {
			delegate?.identifiersDidChange()
		}
	}
	
}

extension String {
	
	var htmlAttributed: NSAttributedString? {
		guard let encodedData = data(using: .utf8) else {return nil}
		let attributeOptions: [String: Any] = [
			NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
			NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
		]
		return try? NSAttributedString(data: encodedData, options: attributeOptions, documentAttributes: nil)
	}
	
	var htmlDecoded: String {
		guard contains("&") else {return self}
		return htmlAttributed?.string ?? self
	}
	
}

extension NSMutableAttributedString {
	
	func setBaseFont(_ baseFont: UIFont) {
		let baseDescriptor = baseFont.fontDescriptor
		beginEditing()
		enumerateAttribute(NSFontAttributeName, in: NSMakeRange(0, length)) { object, range, _ in
			guard let font = object as? UIFont else {return}
			let traits = font.fontDescriptor.symbolicTraits
			//Creates a UIFontDescriptor with the base font, preserving traits of the current font (bold, italics, etc.)
			guard let descriptor = baseDescriptor.withSymbolicTraits(traits) else {return}
			//Converts the fontDescriptor into a UIFont
			let newFont = UIFont(descriptor: descriptor, size: baseDescriptor.pointSize)
			removeAttribute(NSFontAttributeName, range: range)
			addAttribute(NSFontAttributeName, value: newFont, range: range)
		}
		endEditing()
	}
	
}

extension UIViewController {
	
	func present(error: Error,
	             title: String = "Error",
	             animated: Bool = true,
	             additionalActions: [UIAlertAction]? = nil,
	             completion: (() -> Void)? = nil) {
		present(title: title, message: error.localizedDescription)
	}
	
	func present(title: String,
	             message: String,
	             animated: Bool = true,
	             additionalActions: [UIAlertAction]? = nil,
	             completion: (() -> Void)? = nil) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .cancel)
		alertController.addAction(okAction)
		additionalActions?.forEach {alertController.addAction($0)}
		present(alertController, animated: animated, completion: completion)
	}
	
}
