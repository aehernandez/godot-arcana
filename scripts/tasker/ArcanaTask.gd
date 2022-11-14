extends Node
class_name ArcanaTask
signal done

var autostart := true

enum Status {
    INACTIVE,
    ACTIVE,
    SUCCESS,
    CANCELED,
}

var _status := Status.INACTIVE

func get_status():
    return _status

func _exit_tree():
    if _status != Status.SUCCESS:
        _status = Status.CANCELED
    emit_signal("done")

func confirm_done():
    _status = Status.SUCCESS
    queue_free()

func _ready():
    if autostart:
        _status = Status.ACTIVE
        start()

# Override this function with your desired behavior
func start():
    pass

        
