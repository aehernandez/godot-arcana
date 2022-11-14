class_name ArcanaTasker extends Node

signal done_with_tasks

var _task_mutex := Mutex.new()
var _current_task_loop: Callable

# Runs the tasks returned by `get_tasks_func` in a loop. 
# Each time a set of tasks is done the `done_with_tasks` signal is emitted and
# another set of tasks are requested from the input callable.
func set_task_loop(get_tasks_func: Callable):
	if _current_task_loop:
		_task_mutex.lock()
		done_with_tasks.disconnect(_current_task_loop)
		_current_task_loop = null
		_task_mutex.unlock()

	var callable = func(): execute_tasks(get_tasks_func.call())
	done_with_tasks.connect(callable)
	_current_task_loop = callable

	callable.call_deferred()
	return callable

# Executes the given sequence of tasks, emitting the `done_with_tasks` signal when done
func execute_tasks(tasks: Array):
	_task_mutex.lock()
	for task in tasks:
		assert(task is Task)
		assert(task.autostart)
		add_child(task)
		await task.done
	emit_signal("done_with_tasks")
	_task_mutex.unlock()