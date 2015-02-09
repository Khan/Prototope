//
//  Message.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/9/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import swiftz
import swiftz_core

enum Message {
	case ReplacePrototype(Prototype)
}

extension Message: JSONDecode {
	static func fromJSON(jsonValue: JSONValue) -> Message? {
		switch jsonValue {
		case let .JSONObject(dictionary):
			return dictionary["type"]
				>>- MessageTypeEncoding.fromJSON
				>>- { type in
					dictionary["payload"]
					>>- self.decodeMessageType(type)
				}
		default:
			return nil
		}
	}

	static func toJSON(message: Message) -> JSONValue {
		return .JSONObject([
			"type": MessageTypeEncoding.toJSON(message.typeEncoding),
			"payload": encodeMessagePayload(message)
		])
	}

	private var typeEncoding: MessageTypeEncoding {
		switch self {
		case .ReplacePrototype(_): return .ReplacePrototype
		}
	}

	private static func decodeMessageType(type: MessageTypeEncoding)(payload: JSONValue) -> Message? {
		switch type {
		case .ReplacePrototype:
			return Prototype.fromJSON(payload) >>- { .ReplacePrototype($0) }
		}
	}

	private static func encodeMessagePayload(message: Message) -> JSONValue {
		switch message {
		case let .ReplacePrototype(prototype):
			return Prototype.toJSON(prototype)
		}
	}

	enum MessageTypeEncoding: String, JSON {
		case ReplacePrototype = "ReplacePrototype"

		static func fromJSON(jsonValue: JSONValue) -> MessageTypeEncoding? {
			return JString.fromJSON(jsonValue) >>- { MessageTypeEncoding(rawValue: $0) }
		}

		static func toJSON(jsonValue: MessageTypeEncoding) -> JSONValue {
			return JString.toJSON(jsonValue.rawValue)
		}
	}
}
