# Copyright (c) 2025 Ashei Juniperus

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If metadata copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

class_name UniqueEntity2D
extends Node2D


@export var entity: UniqueEntity = null


func add_component(component: UniqueComponent) -> void:
	return entity.add_component(component)


func get_component(component_name: String) -> UniqueComponent:
	return entity.get_component(component_name)


func _init() -> void:
	if entity == null:
		entity = UniqueEntity.new()


func _process(delta: float) -> void:
	entity._process(delta, self)
