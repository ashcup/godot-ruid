# Copyright (c) 2025 Cauldria

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If metadata copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

@tool
class_name UniqueComponentEvent
extends UniqueResource


var component: UniqueComponent = null
var entity: UniqueEntity = null
var node: Node = null

var node_2d: UniqueEntity2D : get = _get_node_2d

var node_3d: UniqueEntity3D : get = _get_node_3d


func _get_node_2d() -> UniqueEntity2D:
	return node as UniqueEntity2D


func _get_node_3d() -> UniqueEntity3D:
	return node as UniqueEntity3D
