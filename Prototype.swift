//
//  Prototype.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/9/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import swiftz
import swiftz_core

struct Prototype {
	var mainScript: NSData
	var images: [String: NSData]
}

extension Prototype: JSON {
	private static func create(mainScript: NSData)(images: [String: NSData]) -> Prototype { return Prototype(mainScript: mainScript, images: images) }

	static func fromJSON(jsonValue: JSONValue) -> Prototype? {
		switch jsonValue {
		case let .JSONObject(dictionary):
			return create
				<^> (dictionary["mainScript"] >>- NSDataJSONCoder.fromJSON)
				<*> (dictionary["images"] >>- JDictionaryFrom<NSData, NSDataJSONCoder>.fromJSON)
		default:
			return nil
		}
	}

	static func toJSON(prototype: Prototype) -> JSONValue {
		return .JSONObject([
			"mainScript": NSDataJSONCoder.toJSON(prototype.mainScript),
			"images": JDictionaryTo<NSData, NSDataJSONCoder>.toJSON(prototype.images)
		])
	}
}

struct NSDataJSONCoder: JSON {
	static func fromJSON(jsonValue: JSONValue) -> NSData? {
		return JString.fromJSON(jsonValue) >>- { NSData(base64EncodedString: $0, options: nil) }
	}

	static func toJSON(data: NSData) -> JSONValue {
		return JString.toJSON(data.base64EncodedStringWithOptions(nil))
	}
}