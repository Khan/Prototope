//
//  ConsoleView.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/11/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

class ConsoleView: UIView {
	private let vibrancyEffectView: UIVisualEffectView
	private let visualEffectView: UIVisualEffectView
	private let textView: UITextView = {
		let textView = UITextView(frame: CGRect())
		textView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
		textView.textColor = UIColor.whiteColor()
		textView.backgroundColor = UIColor.clearColor()
		textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		textView.textContainer.lineFragmentPadding = 0
		textView.editable = false

		return textView
	}()

	func appendConsoleMessage(message: String) {
		textView.textStorage.appendAttributedString(
			NSAttributedString(string: "\(message)\n", attributes: [NSFontAttributeName: UIFont(name: "Menlo", size: 16)!])
		)
		scrollToBottomAnimated(true)
	}

	func scrollToBottomAnimated(animated: Bool) {
		var newContentOffset = textView.contentOffset
		newContentOffset.y = max(0, textView.contentSize.height - textView.bounds.size.height)
		textView.setContentOffset(newContentOffset, animated: animated)
	}

	func reset() {
		textView.textStorage.deleteCharactersInRange(NSMakeRange(0, textView.textStorage.length))
	}

	init() {
		let blurEffect = UIBlurEffect(style: .Dark)
		visualEffectView = UIVisualEffectView(effect: blurEffect)
		visualEffectView.autoresizingMask = .FlexibleWidth | .FlexibleHeight

		vibrancyEffectView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))
		vibrancyEffectView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
		visualEffectView.contentView.addSubview(vibrancyEffectView)

		vibrancyEffectView.contentView.addSubview(textView)

		super.init(frame: CGRect())

		addSubview(visualEffectView)
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has intentionally not been implemented")
	}

}
