# RUID Specification

An RUID is a 128-bit randomly-generated, unique identifier for a resource.

RUIDs provide two major advantages over UUIDs:
1. RUIDs are designed to be more readable than a UUID.
2. RUIDs are designed to be faster to generate by having a simpler structure.

## Example

An example of what an RUID might look like can be found below:

```
2-c5b-94b1-35ad49bb-b1188e8f-c24abf80
```

## Structure

### Version 0

RUID v0 is suitable for typeless objects, such as generic dictionaries.
RUID v0 is not suitable for any use case where the version of RUID used may
change in the future.
This is due to the fact that RUID v0 is the only version of RUID that lacks a
version number in the specification.
Version 0 RUIDs provide a total of 128 random bits.

```
R-RRR-RRRR-RRRRRRRR-RRRRRRRR-RRRRRRRR
```

where:
* `R` = random

### Version 1

RUID v1 is suitable for typeless objects, such as generic dictionaries.
Version 1 RUIDs provide a total of 120 random bits.

```
V-RRR-RRRR-RRRRRRRR-RRRRRRRR-RRRRRRRR
```

where:
* `V` = RUID version
* `R` = random

### Version 2

RUID v2 was designed for smaller object databases containing a large variety of
different object types.
RUID v2 is designed for typed objects, such as class instances and structures.
Version 2 RUIDs provide a total of 64 random bits,
with 56 of the remaining bits being used to identify the type of data being
pointed to by this RUID.

```
V-TTT-TTTT-RRRRRRRR-RRRRRRRR-RRRRRRRR
```

where:
* `V` = RUID version
* `T` = hash code of object's class name
* `R` = random

### Version 3

RUID v3 is a modification of v2 that states that the hash algorithm used to
calculate the hash code of the object's type name is a custom, vendor-specific
function implemented by a developer.

```
V-TTT-TTTT-RRRRRRRR-RRRRRRRR-RRRRRRRR
```

where:
* `V` = RUID version
* `T` = 3 least-significant nibbles of the SHA-256 hash code of the class name
* `R` = random

### Version 4

RUID v4 was designed for larger object databases containing a smaller variety
of different object types compared to v4.
RUID v4 is a modification of v2 that aims to further decrease the collision
rate of objects at the cost of increasing the collision rate of type names.
RUID v4 is designed for typed objects, such as class instances and structures.
Version 4 RUIDs provide a total of 64 random bits,
with 56 of the remaining bits being used to identify the type of data being
pointed to by this RUID,
containing the 56 least-significant bits of the SHA-256 hash code of the
object's type name.
For example,
if the object being hashed were of type `FooBar`,
then the object type would be set to `sha256("FooBar")`.

```
V-RRT-TTTT-RRRRRRRR-RRRRRRRR-RRRRRRRR
```

where:
* `V` = RUID version
* `T` = hash code of object's class name
* `R` = random

### Version 5

RUID v5 is a modification of v5 that states that the hash algorithm used to
calculate the hash code of the object's type name is a custom, vendor-specific
function implemented by a developer.

```
V-RRT-TTTT-RRRRRRRR-RRRRRRRR-RRRRRRRR
```

where:
* `V` = RUID version
* `T` = 3 least-significant nibbles of the SHA-256 hash code of the class name
* `R` = random
