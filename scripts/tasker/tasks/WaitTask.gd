extends ArcanaTask
class_name WaitTask

var timeout_s: float = 10 

static func create(this_timeout_s: float):
    var instance = new()
    instance.timeout_s = this_timeout_s
    return instance

func start():
    await get_tree().create_timer(timeout_s).timeout
    confirm_done()
