//
//  PrototypeListTableViewController.swift
//  Protomath
//
//  Created by Jason Brennan on 2015-06-22.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit


/** Shows a list of Prototypes loaded from the application's bundle and lets you tap to play. */
class PrototypeListTableViewController: UITableViewController {
	
	let prototypeProvider = PrototypeProvider()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
	}

	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return prototypeProvider.prototypes.count
	}
	
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(UITableViewCell.reuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
		cell.accessoryType = .DisclosureIndicator
		cell.textLabel?.text = self.prototypeProvider.prototypes[indexPath.row].name
		
		return cell
	}
	
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		let player = PlayerViewController(path: self.prototypeProvider.prototypes[indexPath.row].mainFileURL)
		self.navigationController?.pushViewController(player, animated: true)
	}


}


extension UITableViewCell {
	/** Provides a default reuse identifier for cells. */
	class var reuseIdentifier: String { return NSStringFromClass(self.self) }
}

