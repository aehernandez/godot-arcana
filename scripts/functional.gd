class_name Functional

# Debounce is a higher-order function that ensures `callable` is invoked only
# once every `wait_time_s` seconds.
# Note: in the current implementation, `callable` must take no arguments and
# any return value is ignored
#
# Example:
# ```
# var do_flip = Functional.debounce(func():
# 	if linear_velocity.x > 0:
# 		$Sprite2D.flip_h = true
# 	else:
# 		$Sprite2D.flip_h = false,
# 	0.5)
#
# #... later
#
# do_flip.call()
# ```
static func debounce(callable: Callable, wait_time_s: float):
	var f = func(data: Dictionary):
		var call_time = float(Time.get_ticks_msec()) / 1000.0
		if data.time + wait_time_s < call_time:
			data.time = call_time
			callable.call_deferred()
	return f.bind({'time': -wait_time_s})