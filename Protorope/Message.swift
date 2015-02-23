//
//  Message.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/9/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import swiftz_core

enum Message {
	/// A message from host to player which replaces the player's prototype with the argument.
	case ReplacePrototype(Prototype)

	/// A message from player to host indicating an exception was hit while a prototype was being played.
	case PrototypeHitException(String)

	/// A message from player to host for a log message hit while the prototype was being played.
	case PrototypeConsoleLog(String)
}

extension Message: JSON {
	static func fromJSON(jsonValue: JSONValue) -> Message? {
		switch jsonValue {
		case let .JSONObject(dictionary):
			return dictionary["type"]
				>>- MessageTypeEncoding.fromJSON
				>>- { typeEncoding in
					dictionary["payload"] >>- self.decodeMessageType(typeEncoding)
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
		case .PrototypeHitException(_): return .PrototypeHitException
		case .PrototypeConsoleLog(_): return .PrototypeConsoleLog
		}
	}

	private static func decodeMessageType(type: MessageTypeEncoding)(payload: JSONValue) -> Message? {
		switch type {
		case .ReplacePrototype:
			return Prototype.fromJSON(payload) >>- { .ReplacePrototype($0) }
		case .PrototypeHitException:
			return JString.fromJSON(payload) >>- { .PrototypeHitException($0) }
		case .PrototypeConsoleLog:
			return JString.fromJSON(payload) >>- { .PrototypeConsoleLog($0) }
		}
	}

	private static func encodeMessagePayload(message: Message) -> JSONValue {
		switch message {
		case let .ReplacePrototype(prototype):
			return Prototype.toJSON(prototype)
		case let .PrototypeHitException(exception):
			return JString.toJSON(exception)
		case let .PrototypeConsoleLog(message):
			return JString.toJSON(message)
		}
	}

	enum MessageTypeEncoding: String, JSON {
		case ReplacePrototype = "ReplacePrototype"
		case PrototypeHitException = "PrototypeHitException"
		case PrototypeConsoleLog = "PrototypeConsoleLog"

		static func fromJSON(jsonValue: JSONValue) -> MessageTypeEncoding? {
			return JString.fromJSON(jsonValue) >>- { MessageTypeEncoding(rawValue: $0) }
		}

		static func toJSON(jsonValue: MessageTypeEncoding) -> JSONValue {
			return JString.toJSON(jsonValue.rawValue)
		}
	}
}
