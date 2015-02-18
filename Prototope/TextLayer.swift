//
//  TextLayer.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/15/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

/**
	This layer draws text, optionally with word wrapping.

	It presently rasterizes the text to a bitmap, so applying a scale factor will result in fuzziness.

	It does not yet support truncation or heterogeneously styled text.

	If text is not being wrapped, then the layer's size will automatically grow to accommodate the full string. If text *is* being wrapped, the layer will respect its given width but will adjust its height to accommodate the full string. Except when the layer's size is directly being changed (i.e. via layer.width or layer.bounds.width--but not layer.frame.width), the layer's origin will be preserved if the size changes to accommodate the text. If the layer's size is changed direclty, then its position will be preserved.
*/
public class TextLayer: Layer {
	
	/** Text alignment */
	public enum Alignment {
		/** Visually left aligned */
		case Left
		
		/** Visually centered */
		case Center
		
		/** Visually right aligned */
		case Right
		
		/** Fully-justified. The last line in a paragraph is natural-aligned. */
		case Justified
		
		/** Indicates the default alignment for script */
		case Natural
		
		internal func toNSTextAlignment() -> NSTextAlignment {
			switch self {
			case .Left: return .Left
			case .Center: return .Center
			case .Right: return .Right
			case .Justified: return .Justified
			case .Natural: return .Natural
			}
		}
		
		internal init(nsTextAlignment: NSTextAlignment) {
			switch nsTextAlignment {
			case .Left: self = .Left
			case .Center: self = .Center
			case .Right: self = .Right
			case .Justified: self = .Justified
			case .Natural: self = .Natural
			}
		}
	}
	
	public var text: String? {
		get {
			return label.text
		}
		set {
			label.text = newValue
			updateSizePreservingOrigin()
		}
	}

	public var fontName: String = "Futura" {
		didSet {
			updateFont()
			updateSizePreservingOrigin()
		}
	}

	public var fontSize: Double = 16 {
		didSet {
			updateFont()
			updateSizePreservingOrigin()
		}
	}

	public var textColor: Color {
		get { return Color(label.textColor) }
		set { label.textColor = newValue.uiColor }
	}

	public var wraps: Bool {
		get {
			return label.numberOfLines == 0
		}
		set {
			label.numberOfLines = newValue ? 0 : 1
			updateSizePreservingOrigin() // Adjust width/height as necessary for new wrapping mode.
		}
	}
	
	public var textAlignment: Alignment {
		get {
			return Alignment(nsTextAlignment: label.textAlignment)
		}
		set {
			label.textAlignment = newValue.toNSTextAlignment()
			//No need to adjust size, since changing alignment doesn't influence it
		}
	}
	
	/** Distance from top of layer to the first line's baseline */
	public var baselineHeight: Double {
		return Double(label.font.ascender)
	}
	
	/** Aligns this layer with the first baseline of the other layer */
	public func alignWithBaselineOf(otherLayer: TextLayer) {
		var delta = pixelAwareCeil(otherLayer.baselineHeight-baselineHeight)
		
		var frame = self.frame
		frame.origin.y = otherLayer.frame.minY + delta
		self.frame = frame
	}
	
	public override var frame: Rect {
		didSet {
			// Respect the new width; resize height so as not to truncate.
			if wraps {
				updateSizePreservingOrigin()
			}
		}
	}

	public override var bounds: Rect {
		didSet {
			// Respect the new width; resize height so as not to truncate.
			if wraps {
				let position = self.position
				label.sizeToFit()
				self.position = position
			}
		}
	}

	private func updateFont() {
		label.font = UIFont(name: fontName, size: CGFloat(fontSize))!
		updateSizePreservingOrigin()
	}

	private func updateSizePreservingOrigin() {
		label.sizeToFit()
	}

	private var label: UILabel {
		return self.view as! UILabel
	}

	public init(parent: Layer? = Layer.root, name: String? = nil) {
		super.init(parent: parent, name: name, viewClass: UILabel.self)
		updateFont()
	}
}