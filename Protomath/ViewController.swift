//
//  ViewController.swift
//  Protomath
//
//  Created by Jason Brennan on 2015-06-22.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	
	let prototypeProvider = PrototypeProvider()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
	}

	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return prototypeProvider.numberOfPrototypes()
	}
	
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(UITableViewCell.reuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
		cell.accessoryType = .DisclosureIndicator
		cell.textLabel?.text = self.prototypeProvider.prototypeNameAtIndex(indexPath.row)
		
		return cell
	}
	
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		let player = PlayerViewController(path: self.prototypeProvider.pathForPrototypeAtIndex(indexPath.row))
		self.navigationController?.pushViewController(player, animated: true)
	}


}


extension UITableViewCell {
	class var reuseIdentifier: String { return NSStringFromClass(self.self) }
}

