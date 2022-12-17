@tool
extends Control
class_name HealthBar

var fg: ColorRect = ColorRect.new()
var bg: ColorRect = ColorRect.new()

@export var always_visible := false
@export var foreground_color: Color = Color.GREEN:
	get:
		return foreground_color
	set(color):
		foreground_color = color
		fg.color = color
@export var background_color: Color = Color.GRAY:
	get:
		return background_color
	set(color):
		background_color = color
		bg.color = color

@export var node_path: NodePath = ^"../"
@onready var node = get_node(node_path)

@export_range(0, 1, 0.1) var percent: float = 1: 
	get:
		return percent
	set(value):
		percent = value
		fg.set_size(Vector2(percent * size.x, size.y))

func on_health_change(manager: HealthManager):
	if not is_instance_valid(manager):
		return

	var max_health = float(manager.max_health)
	var new_health = float(manager.health)
	percent = new_health / max_health
	
	if always_visible:
		visible = true
	else:
		if percent < 1.0:
			visible = true
		else:
			visible = false

func _instance_children():
	if is_instance_valid(fg):
		fg.queue_free()
	if is_instance_valid(bg):
		bg.queue_free()

	bg = ColorRect.new()
	bg.name = "Bg"
	bg.color = background_color
	bg.size = size
	add_child(bg)

	fg = ColorRect.new()
	fg.name = "Fg"
	fg.color = foreground_color
	fg.size = size
	add_child(fg)

func _ready():
	resized.connect(_instance_children)
	_instance_children()
	if not Engine.is_editor_hint():
		assert("health_manager" in node)
		on_health_change(node.health_manager)
		node.health_manager.on_health_change.connect(on_health_change)
