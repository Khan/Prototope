//
//  ExceptionView.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/10/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

class ExceptionView: UIView {

	var exception: String? {
		get { return exceptionTextView.text }
		set { exceptionTextView.text = newValue }
	}

	private let protonopeLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Futura", size: 16)
		label.textColor = UIColor.whiteColor()
		label.text = "protonope!"
		return label
	}()

	private let exceptionTextView: UITextView = {
		let textView = UITextView()
		textView.font = UIFont(name: "Menlo-Regular", size: 14)
		textView.textColor = UIColor.whiteColor()
		textView.backgroundColor = UIColor.clearColor()
		textView.textContainerInset = UIEdgeInsets()
		textView.textContainer.lineFragmentPadding = 0
		textView.editable = false
		return textView
	}()

	init() {
		super.init(frame: CGRect())
		backgroundColor = Style.warning

		addSubview(exceptionTextView)
		addSubview(protonopeLabel)
	}

	override func layoutSubviews() {
		let insetBounds = CGRectInset(bounds, 20, 20)

		protonopeLabel.sizeToFit()
		protonopeLabel.frame.origin = insetBounds.origin

		exceptionTextView.frame = insetBounds
		exceptionTextView.frame.origin.y = protonopeLabel.frame.maxY + 20
		exceptionTextView.frame.size.height -= exceptionTextView.frame.origin.y

		super.layoutSubviews()
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has intentionally not been implemented")
	}
}
