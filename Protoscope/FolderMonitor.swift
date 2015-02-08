//
//  FolderMonitor.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/7/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation

class FolderMonitor {
	private let presenter: Presenter

	var everythingDidChangeHandler: () -> Void {
		get { return presenter.everythingDidChangeHandler }
		set { presenter.everythingDidChangeHandler = newValue }
	}

	init(folderPath: NSURL) {
		presenter = Presenter(url: folderPath)
		NSFileCoordinator.addFilePresenter(presenter)
	}

	deinit {
		stop()
	}

	func stop() {
		NSFileCoordinator.removeFilePresenter(presenter)
	}

	@objc private class Presenter: NSObject, NSFilePresenter {
		let url: NSURL
		var everythingDidChangeHandler: () -> Void = {}

		init(url: NSURL) {
			self.url = url
		}

		var presentedItemURL: NSURL? {
			return url
		}

		var presentedItemOperationQueue: NSOperationQueue {
			// do something less ridiculous
			return NSOperationQueue.mainQueue()
		}

		private func presentedItemDidChange() {
			everythingDidChangeHandler()
		}
	}
}
