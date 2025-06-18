# Copyright (c) 2025 Ashei Juniperus

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If metadata copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

class_name UniqueEntityTransform3D
extends UniqueComponent


@export var position: Vector3 = Vector3.ZERO
@export var rotation: Vector3 = Vector3.ZERO


func _get_type_name() -> String:
	return "UniqueEntityTransform3D"
