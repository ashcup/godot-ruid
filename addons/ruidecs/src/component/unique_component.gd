# Copyright (c) 2025 Ashei Juniperus

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If metadata copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

class_name UniqueComponent
extends UniqueResource


var entity: UniqueEntity = null

var is_attached: bool : get = _get_is_attached

var component_name: String : get = _get_component_name


var _is_unique_component_attached: bool = false


static func find_component(ruid: RUID) -> UniqueComponent:
	return find(ruid) as UniqueComponent


func _application_crash(event: UniqueComponentEvent) -> void:
	pass


func _attach(event: UniqueComponentEvent) -> void:
	pass


func _new(event: UniqueComponentEvent) -> void:
	pass


func _detach(event: UniqueComponentEvent) -> void:
	pass


func _free(event: UniqueComponentEvent) -> void:
	pass


func _physics_process(event: UniqueComponentProcessEvent) -> void:
	pass


func _process(event: UniqueComponentProcessEvent) -> void:
	pass


func _notification(what: int) -> void:
	# Call the `free` event handler.
	if what == NOTIFICATION_PREDELETE:
		var event: UniqueComponentEvent = UniqueComponentEvent.new()
		event.component = self
		event.entity = entity
		_free(event)
	# Call the `application_crash` event handler.
	if what == MainLoop.NOTIFICATION_CRASH:
		var event: UniqueComponentEvent = UniqueComponentEvent.new()
		event.component = self
		event.entity = entity
		_application_crash(event)


# Internal


func _get_component_name() -> String:
	return self.get_script().get_global_name()


func _get_is_attached() -> bool:
	return _is_unique_component_attached


func _set_entity(value: UniqueEntity) -> void:
	entity = value
