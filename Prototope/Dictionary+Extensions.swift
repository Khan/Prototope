//
//  Dictionary+Extensions.swift
//  Prototope
//
//  Created by Andy Matuschak on 11/14/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

/** Creates a dictionary from an array of key-value pairs. */
func dictionaryFromElements<Key, Value>(elements: [(Key, Value)]) -> [Key: Value] {
	var dictionary = [Key: Value](minimumCapacity: elements.count)
	for (key, value) in elements {
		dictionary[key] = value
	}

	return dictionary
}

func +<Key, Value>(var a: [Key: Value], b: [Key: Value]) -> [Key: Value] {
	for (k, v) in b {
		a[k] = v
	}
	return a
}

func -<Key, Value>(var a: [Key: Value], b: [Key: Value]) -> [Key: Value] {
	for (k, _) in b {
		a.removeValueForKey(k)
	}
	return a
}
