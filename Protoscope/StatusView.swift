//
//  StatusView.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/7/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

class StatusView: UIView {
	private let prototopeP: UIImageView = {
		let icon = UIImage(named: "PrototopeP")
		let iconView = UIImageView(image: icon)
		return iconView
	}()

	private let statusLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Futura", size: 20)
		label.textColor = UIColor.whiteColor()
		return label
	}()

	override init() {
		super.init(frame: CGRect())
		backgroundColor = Style.cyan
		addSubview(prototopeP)
		addSubview(statusLabel)

		statusLabel.text = "Waiting for protorope…"
	}

	override func layoutSubviews() {
		prototopeP.sizeToFit()
		prototopeP.center.x = bounds.midX
		prototopeP.center.y = bounds.midY - 90

		statusLabel.sizeToFit()
		statusLabel.center.x = bounds.midX
		statusLabel.center.y = bounds.midY + 30
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has intentionally not been implemented")
	}
}
