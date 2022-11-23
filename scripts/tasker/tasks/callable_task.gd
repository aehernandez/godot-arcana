extends ArcanaTask
class_name CallableTask

var callable = null

static func create(c: Callable) -> CallableTask:
    var instance = new()
    instance.callable = c
    return instance

func start():
    assert(callable)
    callable.call_deferred()
    confirm_done()
        
