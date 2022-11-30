# Godot Arcana

This repository is a growing collection of helpful Godot4 utility scripts, shaders, and node extensions.

## Scripts
[UUID](scripts/uuid.gd) generates unique identification strings, based off of [binogure-studio/godot-uuid](https://github.com/binogure-studio/godot-uuid)'s implementation.

[Random](scripts/random.gd) provides utilities for choosing random elements from various containers.

[Functional](scripts/functional.gd) provides utilities for first order functions introduced in Godot4.

[Tasker](scripts/tasker) is framework to create and run coroutines within Godot's node lifecycle from task primitives.


## Nodes

[CollisionSprite2D](nodes/collision_sprite_2d.gd) automatically creates a CollisionSprite2D polygon collider from an input sprite.

[ZoomCamera2D](nodes/zoom_camera_2d.gd) extends Camera2D by listening to input events in order to allow player's to control camera zoom levels.


## Shaders

[HsvModify](shaders/hsv_modify.gdshader) provides options to dynamically modify a texture's global hue, saturation, and value properties efficiently.
