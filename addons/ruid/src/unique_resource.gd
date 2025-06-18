# Copyright (c) 2025 Ashei Juniperus

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If metadata copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

class_name UniqueResource
extends Resource


static var _registered_unique_resources: Dictionary[RUID, UniqueResource]


@export var ruid: RUID = RUID.v4(get_class())


static func find(ruid: RUID) -> UniqueResource:
	return _registered_unique_resources[ruid]


static func find_by(pattern: Callable, query: Variant = null) -> Array[UniqueResource]:
	var results: Array[UniqueResource] = []
	for unique_resource: UniqueResource in _registered_unique_resources.values():
		if pattern.call(unique_resource, query):
			results.append(unique_resource)
	return results


static func find_by_hash(query: String) -> Array[UniqueResource]:
	return find_by(_find_by_hash_pattern, query)


static func find_by_type_name(query: String) -> Array[UniqueResource]:
	return find_by(_find_by_type_name_pattern, query)


static func find_by_type_hash(query: int) -> Array[UniqueResource]:
	return find_by(_find_by_type_hash_pattern, query)


static func _find_by_hash_pattern(unique_resource: UniqueResource, query: Variant) -> bool:
	return unique_resource.hash() == query


static func _find_by_type_name_pattern(unique_resource: UniqueResource, query: Variant) -> bool:
	return unique_resource.get_class() == query


static func _find_by_type_hash_pattern(unique_resource: UniqueResource, query: Variant) -> bool:
	return unique_resource.ruid.get_object_type() == query


func clone() -> UniqueResource:
	var duplication_target: UniqueResource = duplicate(true)
	duplication_target.ruid = RUID.v4(get_class())
	return duplication_target


func _init() -> void:
	_register_unique_resource()


func _register_unique_resource() -> void:
	_registered_unique_resources[ruid] = self
