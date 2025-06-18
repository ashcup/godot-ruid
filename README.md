# RUID

A RUID (Random Unique IDentifier) is a 128-bit randomly-generated, unique identifier for a resource.

## Usage

Here's an example script that creates a new RUID.

```php
class_name YourAwesomeClass
extends Node


# Create a new RUID.
var ruid: RUID = RUID.NIL


func equals(other: YourAwesomeClass) -> bool:
    return ruid == other.ruid


func _ready() -> void:
    if ruid.is_nil():
        ruid = RUID.v4("YourAwesomeClass")
```

# RUIDECS

RUIDECS is an ECS (Entity Component System) model made for Godot.

## Usage

Here's an example script that creates an entity.

```php
# Create a new entity.
var entity: UniqueEntity = UniqueEntity.new()

func _ready() -> void:
    # Create a new component.
    var component: UniqueComponent = YourAwesomeComponent.new()

    # Add the component to the entity.
    entity.add_component(component)


func _process(delta: float) -> void:
    # Get the component later.
    var component: YourAwesomeComponent = entity.get_component("YourAwesomeComponent") as YourAwesomeComponent

    # Now you can something with the component.
    component.your_awesome_value = delta
```
