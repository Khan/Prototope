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
		get { return exceptionLabel.text }
		set { exceptionLabel.text = newValue }
	}

	private let exceptionLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Futura", size: 16)
		label.numberOfLines = 0
		label.textColor = UIColor.whiteColor()
		return label
	}()

	override init() {
		super.init(frame: CGRect())
		backgroundColor = Style.warning

		addSubview(exceptionLabel)
	}

	override func layoutSubviews() {
		exceptionLabel.frame = CGRectInset(bounds, 20, 20)
		super.layoutSubviews()
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has intentionally not been implemented")
	}
}
