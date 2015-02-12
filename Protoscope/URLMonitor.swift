//
//  URLMonitor.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/7/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation

class URLMonitor {
	let URL: NSURL
	private let presenter: Presenter

	var everythingDidChangeHandler: () -> Void {
		get { return presenter.everythingDidChangeHandler }
		set { presenter.everythingDidChangeHandler = newValue }
	}

	init(URL: NSURL) {
		self.URL = URL
		presenter = Presenter(url: URL)
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

		@objc var presentedItemURL: NSURL? {
			return url
		}

		@objc var presentedItemOperationQueue: NSOperationQueue {
			// TODO: something less ridiculous
			return NSOperationQueue.mainQueue()
		}

		@objc private func presentedItemDidChange() {
			everythingDidChangeHandler()
		}

		@objc private func presentedSubitemDidAppearAtURL(url: NSURL) {
			println("Subitem appared: \(url)")
			everythingDidChangeHandler()
		}

		@objc private func presentedSubitemDidChangeAtURL(url: NSURL) {
			println("Subitem changed: \(url)")
			if !url.lastPathComponent!.hasPrefix(".") {
				everythingDidChangeHandler()
			}
		}

		@objc private func presentedSubitemAtURL(oldURL: NSURL, didMoveToURL newURL: NSURL) {
			println("Subitem moved: \(oldURL) -> \(newURL)")
			everythingDidChangeHandler()
		}

		@objc private func accommodatePresentedSubitemDeletionAtURL(url: NSURL, completionHandler: (NSError!) -> Void) {
			println("Subitem deleted: \(url)")
			everythingDidChangeHandler()
			completionHandler(nil)
		}

		@objc private func accommodatePresentedItemDeletionWithCompletionHandler(completionHandler: (NSError!) -> Void) {
			println("Item disappeared")
			fatalError("Unimplemented")
		}
	}
}
