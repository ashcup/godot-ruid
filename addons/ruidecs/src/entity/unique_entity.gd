# Copyright (c) 2025 Ashei Juniperus

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If metadata copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

class_name UniqueEntity
extends UniqueResource


@export var components: Dictionary[String, UniqueComponent]


func add_component(component: UniqueComponent) -> void:
	var type_name: String = component.get_script().get_global_name()
	# Add the component to this entity.
	print("Adding component %s" % type_name)
	components[type_name] = component
	# Emit the associated event.
	var event: UniqueComponentEvent = UniqueComponentEvent.new()
	event.component = component
	event.entity = self
	component._set_entity(self)
	component._attach(event)


func get_component(component_name: String) -> UniqueComponent:
	if component_name not in components:
		return null
	return components[component_name]


func find_components_by(pattern: Callable, query: Variant = null) -> Array[UniqueComponent]:
	var results: Array[UniqueComponent] = []
	for component: UniqueComponent in components.values():
		if pattern.call(component, query):
			results.append(component)
	return results


func remove_all_components() -> void:
	for component_name in components:
		remove_component(component_name)


func remove_component(component_name: String) -> void:
	# Get the component to remove.
	var component: UniqueComponent = components[component_name]
	# Emit the associated event.
	var event: UniqueComponentEvent = UniqueComponentEvent.new()
	event.component = component
	event.entity = self
	component._detach(event)
	component._set_entity(null)
	# Remove the component from this entity.
	components.erase(component_name)


func remove_component_by_reference(component: UniqueComponent) -> void:
	remove_component(component.type_name)


func _process(delta: float, node: Node) -> void:
	var event_prototype: UniqueComponentProcessEvent = UniqueComponentProcessEvent.new()
	event_prototype.delta = delta
	event_prototype.entity = self
	for component: UniqueComponent in components.values():
		var event: UniqueComponentProcessEvent = event_prototype.clone()
		event.component = component
		component._process(event)


func _physics_process(delta: float, node: Node) -> void:
	var event_prototype: UniqueComponentProcessEvent = UniqueComponentProcessEvent.new()
	event_prototype.delta = delta
	event_prototype.entity = self
	for component: UniqueComponent in components.values():
		var event: UniqueComponentProcessEvent = event_prototype.clone()
		event.component = component
		component._physics_process(event)


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		remove_all_components()
