# Copyright (c) 2025 Ashei Juniperus

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

## An RUID is a 128-bit randomly-generated, unique identifier for a resource.
## RUIDs provide two major advantages over UUIDs:
## 1. RUIDs are designed to be more readable than a UUID.
## 2. RUIDs are designed to be faster to generate by having a simpler structure.
## An example of what an RUID might look like can be found below:
## 2c5b-94b1-35ad49bb-b1188e8f-c24abf80
@tool
class_name RUID
extends Resource


static var NIL: RUID = RUID.from_ints(0x00000000, 0x00000000, 0x00000000, 0x00000000)
static var OMNI: RUID = RUID.from_ints(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF)


@export var metadata: int = 0x00000000
@export var random_a: int = 0x00000000
@export var random_b: int = 0x00000000
@export var random_c: int = 0x00000000


var version: int : get = get_version, set = set_version

var object_type: Variant : get = get_object_type, set = set_object_type


static func from_array(array: Array[int]) -> RUID:
	var ruid: RUID = _duplicate_nil()
	ruid.metadata = array[0]
	ruid.random_a = array[1]
	ruid.random_b = array[2]
	ruid.random_c = array[3]
	return ruid


static func from_ints(_a: int, _b: int, _c: int, _d: int) -> RUID:
	var ruid: RUID = RUID.new()
	ruid.metadata = _a
	ruid.random_a = _b
	ruid.random_b = _c
	ruid.random_c = _d
	return ruid


static func random() -> RUID:
	var ruid: RUID = _duplicate_nil()
	ruid.randomize()
	return ruid


static func v4(object_type: String) -> RUID:
	var ruid: RUID = random()
	# Save the RUID version to the RUID metadata.
	ruid.set_version(4)
	ruid._set_object_type_v4(object_type)
	return ruid


func equals(value: RUID) -> bool:
	return _get_hash_code() == value._get_hash_code()


func get_object_type() -> int:
	return _get_object_type_hash()


func get_version() -> int:
	return (metadata & 0xF0000000) >> (4 * 7)


func hash() -> int:
	return _get_hash_code()


func randomize() -> void:
	metadata = randi()
	random_a = randi()
	random_b = randi()
	random_c = randi()


func set_object_type(value: Variant) -> void:
	if is_instance_of(value, TYPE_INT):
		_set_object_type_hash(value)
		return
	if is_instance_of(value, TYPE_STRING):
		match get_version():
			4:
				_set_object_type_v4(value)
				return
		_push_invalid_ruid_version_error()
		return
	const error_message: String = "RUID object type names cannot be of type `%s`."
	push_error(error_message % value.get_class())


func set_version(value: int) -> void:
	metadata &= 0x0FFFFFFF
	metadata |= value << (4 * 7)


func to_json() -> String:
	return ("\"%s\"" % to_string())


## Convert this RUID into a string.
## Example result: `"9-c5b-94b1-35ad49bb-b1188e8f-c24abf80"`
func to_string() -> String:
	return (
		_to_string_split(metadata) +
		"-" +
		_to_string_contiguous(random_a) +
		"-" +
		_to_string_contiguous(random_b) +
		"-" +
		_to_string_contiguous(random_c)
	)


func to_array() -> Array[int]:
	var array: Array[int] = [ metadata, random_a, random_b, random_c ]
	return array


func to_bytes() -> PackedByteArray:
	return to_packed_array().to_byte_array()


func to_packed_array() -> PackedInt32Array:
	var array: PackedInt32Array = [ metadata, random_a, random_b, random_c ]
	return array


static func _duplicate_nil() -> RUID:
	return RUID.from_ints(NIL.metadata, NIL.random_a, NIL.random_b, NIL.random_c)


static func _duplicate_omni() -> RUID:
	return RUID.from_ints(OMNI.metadata, OMNI.random_a, OMNI.random_b, OMNI.random_c)


func _get_hash_code() -> int:
	return ((metadata * 11) ^ ((random_a * 13) << 1)) * ((random_b * 17) ^ ((random_c * 23) << 1))


func _get_object_type_hash() -> int:
	return (metadata & 0x000FFFFF)


func _push_invalid_ruid_version_error() -> void:
	push_error("Invalid RUID version: %X" % get_version())


func _set_object_type_hash(value: int) -> void:
	match get_version():
		4:
			_set_object_type_hash_v4(value)
			return
	_push_invalid_ruid_version_error()


func _set_object_type_hash_v4(value: int) -> void:
	# Save the type hash to the RUID metadata.
	const mask: int = 0xF00000FF
	metadata &= mask
	metadata |= (value << 8) & mask


func _set_object_type_v4(value: String) -> void:
	# Calculate the type hash.
	var ruid_type_sha_256: PackedByteArray = value.sha256_buffer()
	var ruid_type_hash: int = ruid_type_sha_256[0]
	for i in range(1, 2):
		ruid_type_hash |= ruid_type_sha_256[i] << (8 * i)
	ruid_type_hash &= 0x000FFFFF
	# Save the type hash to the RUID metadata.
	_set_object_type_hash(ruid_type_hash)


func _to_string_contiguous(value: int) -> String:
	return ("%x" % metadata).pad_zeros(8)


func _to_string_split(value: int) -> String:
	var bottom_half: int = value & 0x0000FFFF
	var top_half: int = (value & 0xFFFF0000) >> 4
	var top_half_string: String = ("%x" % top_half).pad_zeros(4)
	var bottom_half_string: String = ("%x" % bottom_half).pad_zeros(4)
	return (top_half_string + "-" + bottom_half_string)
