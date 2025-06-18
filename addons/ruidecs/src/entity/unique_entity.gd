# Copyright (c) 2025 Ashei Juniperus

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If metadata copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

class_name UniqueEntity
extends UniqueResource


@export var components: Array[UniqueComponent]


var _component_lookup_table: Dictionary[String, UniqueComponent]


static func find_entity(ruid: RUID) -> UniqueEntity:
	return find(ruid) as UniqueEntity


func add_component(component: UniqueComponent) -> void:
	# Add the component to this entity.
	components.append(component)
	_register_component(component)
	# Emit the associated event.
	var event: UniqueComponentEvent = UniqueComponentEvent.new()
	event.component = component
	event.entity = self
	component._set_entity(self)
	component._attach(event)


func get_component(component_name: String) -> UniqueComponent:
	if component_name not in _component_lookup_table:
		return null
	return _component_lookup_table[component_name]


func find_components_by(pattern: Callable, query: Variant = null) -> Array[UniqueComponent]:
	var results: Array[UniqueComponent] = []
	for component: UniqueComponent in components:
		if pattern.call(component, query):
			results.append(component)
	return results


func remove_all_components() -> void:
	for component_name in _component_lookup_table:
		remove_component(component_name)


func remove_component(component_name: String) -> void:
	# Get the component to remove.
	var component: UniqueComponent = _component_lookup_table[component_name]
	# Emit the associated event.
	var event: UniqueComponentEvent = UniqueComponentEvent.new()
	event.component = component
	event.entity = self
	component._detach(event)
	component._set_entity(null)
	# Remove the component from this entity.
	components.remove_at(components.find(component))
	_unregister_component(component)


func remove_component_by_reference(component: UniqueComponent) -> void:
	remove_component(component.component_name)


func _init() -> void:
	_init_component_lookup_table()


func _process(delta: float, node: Node) -> void:
	var event_prototype: UniqueComponentProcessEvent = UniqueComponentProcessEvent.new()
	event_prototype.delta = delta
	event_prototype.entity = self
	for component: UniqueComponent in _component_lookup_table.values():
		var event: UniqueComponentProcessEvent = event_prototype.clone()
		event.component = component
		component._process(event)


func _physics_process(delta: float, node: Node) -> void:
	var event_prototype: UniqueComponentProcessEvent = UniqueComponentProcessEvent.new()
	event_prototype.delta = delta
	event_prototype.entity = self
	for component: UniqueComponent in _component_lookup_table.values():
		var event: UniqueComponentProcessEvent = event_prototype.clone()
		event.component = component
		component._physics_process(event)


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		remove_all_components()


# Internal


func _build_component_lookup_table() -> void:
	_component_lookup_table.clear()
	for component in components:
		_register_component(component)


func _init_component_lookup_table() -> void:
	if _component_lookup_table == null:
		_component_lookup_table = {}


func _register_component(component: UniqueComponent) -> void:
	_component_lookup_table[component.component_name] = component


func _unregister_component(component: UniqueComponent) -> void:
	_component_lookup_table.erase(component.component_name)
