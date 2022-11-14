extends Node
class_name ArcanaTask
signal done
signal canceled

var autostart = true

var _task_confirmed_done = false

func _exit_tree():
    if not _task_confirmed_done:
        emit_signal("canceled")

func start():
    pass

func confirm_done():
    _task_confirmed_done = true
    emit_signal("done")
    queue_free()

func _ready():
    if autostart:
        start()
        
