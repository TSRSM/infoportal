//
//  UpdatesViewController.swift
//  InfoPortal
//
//  Created by Kabir Oberai on 28/01/17.
//  Copyright © 2017 Kabir Oberai. All rights reserved.
//

import UIKit

class UpdatesViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var updates: [Update] = []
	
	@IBAction func logoutTapped(_ sender: UIBarButtonItem) {
		navigationController?.dismiss(animated: true) {
			API.logout(error: {
				UIApplication.shared.keyWindow?.rootViewController?.present(error: $0)
			}, success: nil)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		fetchUpdates()
		IdentifierManager.shared.delegate = self
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 88
		tableView.contentInset.top += 16
	}
	
	func fetchUpdates() {
		let refs = IdentifierManager.shared.identifiers.map { $0.ref }
		API.updates(filter: refs, error: {
			self.present(error: $0)
		}, success: {
			self.updates = $0
			self.tableView.reloadData()
		})
	}
	
}

extension UpdatesViewController: IdentifierManagerDelegate {
	
	func identifiersDidChange() {
		fetchUpdates()
	}
	
}

extension UpdatesViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return updates.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let update = updates[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateCell", for: indexPath) as! UpdateCell
		cell.titleLabel.text = update.title
		cell.targetLabel.text = update.targetName
		cell.authorLabel.text = update.author
		let content = update.content.htmlAttributed?.mutableCopy() as? NSMutableAttributedString
		content?.setBaseFont(.systemFont(ofSize: UIFont.systemFontSize))
		cell.contentTextView.attributedText = content
		return cell
	}
	
}

extension UpdatesViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
}
