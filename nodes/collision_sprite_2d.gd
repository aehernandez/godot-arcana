@tool
class_name CollisionSprite2D extends CollisionPolygon2D
## Create a CollisionPolygon2D from an existing Sprite2D node

@export_node_path("Sprite2D") var sprite_path: NodePath:
	set(value):
		sprite_path = value
		_update_polygon()

## Controls how accurately the polygon will cover the bitmap: a lower param 
## epsilon corresponds to more points in the polygons.
@export var epsilon: float = 2.0:
	set(value):
		epsilon = value
		_update_polygon()

func _update_polygon():
	if not Engine.is_editor_hint():
		# Do nothing if we're in-game
		return

	var sprite = get_node(sprite_path) as Sprite2D

	if not sprite:
		return

	var bitmap = BitMap.new()
	var image = sprite.texture.get_image().duplicate()

	# If the Sprite2D's transform has a non-unit scale, attempt to reize the image
	# So the resulting polygon is of the same width/height
	if not sprite.scale.is_equal_approx(Vector2.ONE):
		image.resize(image.get_width() * sprite.scale.x, image.get_height() * sprite.scale.y, Image.INTERPOLATE_NEAREST)

	bitmap.create_from_image_alpha(image)
	
	# opaque_to_polygons returns a list of resulting polygons
	# here, we naively pick the first
	var emitted_polygons = bitmap.opaque_to_polygons(Rect2(Vector2(), bitmap.get_size()), epsilon)
	var emitted_polygon: PackedVector2Array = emitted_polygons[0]

	if not sprite.centered:
		polygon = emitted_polygon
	else:
		# Adjust the polygon so it's center aligned with the sprite
		var half_width = image.get_width() / 2
		var half_height = image.get_height() / 2
		var offset = Vector2(half_width, half_height)

		var values = PackedVector2Array()
		for point in emitted_polygon:
			values.append(point - offset)

		polygon = values
