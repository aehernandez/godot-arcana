class_name ZoomCamera2D extends Camera2D
# 2D Camera that handles zoom levels via user input.
# Ensure that `camera_zoom_in` and `camera_zoom_out` input events.

@export var zoom_speed: float = 0.05
@export var zoom_limit_max: float = 2.5:
    get:
        return zoom_limit_max
    set(value):
        zoom_limit_max = value
        _zoom_limit_v_max = Vector2(value, value)
@export var zoom_limit_min: float = 0.75:
    get:
        return zoom_limit_min
    set(value):
        zoom_limit_min = value
        _zoom_limit_v_min = Vector2(value, value)
@export var zoom_increment: float = 0.1:
    get:
        return zoom_increment
    set(value):
        zoom_increment = value
        _zoom_inc_v = Vector2(zoom_increment, zoom_increment)

var _zoom_limit_v_max := Vector2(zoom_limit_max, zoom_limit_max)
var _zoom_limit_v_min := Vector2(zoom_limit_min, zoom_limit_min)
var _zoom_inc_v := Vector2(zoom_increment, zoom_increment)

func _enter_tree():
    assert(ProjectSettings.has_setting("input/camera_zoom_in"))
    assert(ProjectSettings.has_setting("input/camera_zoom_out"))

func _input(event: InputEvent):
    if event.is_action_released("camera_zoom_in"):
        create_tween().tween_property(
            self,
            "zoom",
            clamp(zoom + _zoom_inc_v, _zoom_limit_v_min, _zoom_limit_v_max),
            zoom_speed
        )
    elif event.is_action_released("camera_zoom_out"):
        create_tween().tween_property(
            self,
            "zoom",
            clamp(zoom - _zoom_inc_v, _zoom_limit_v_min, _zoom_limit_v_max),
            zoom_speed
        )
