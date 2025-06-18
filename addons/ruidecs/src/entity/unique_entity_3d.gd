# Copyright (c) 2025 Ashei Juniperus

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If metadata copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

class_name UniqueEntity3D
extends Node3D


@export var entity: UniqueEntity = null


func add_component(component: UniqueComponent) -> void:
	return entity.add_component(component)


func get_component(component_name: String) -> UniqueComponent:
	return entity.get_component(component_name)


func _init() -> void:
	if entity == null:
		entity = UniqueEntity.new()


func _process(delta: float) -> void:
	if get_component("UniqueEntityTransform3D") == null:
		add_component(UniqueEntityTransform3D.new())
	var transform_component: UniqueEntityTransform3D = get_component("UniqueEntityTransform3D")
	# Send the previous transform.
	transform_component.position = position
	transform_component.rotation = rotation
	# Process the entity.
	entity._process(delta, self)
	# Receive the new transform.
	position = transform_component.position
	rotation = transform_component.rotation


func _physics_process(delta: float) -> void:
	entity._physics_process(delta, self)
