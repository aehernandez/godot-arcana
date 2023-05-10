class_name HashSet extends RefCounted

var _data = {}

func _init(array: Array = []):
	for e in array:
		add(e)

func _hash(element: Object) -> int:
	return element.get_instance_id()

func add(element: Object):
	_data[_hash(element)] = element

func remove(element: Object) -> bool:
	return _data.erase(_hash(element))

func has(element: Object):
	return _data.has(_hash(element))

func values() -> Array:
	return _data.values()

func size() -> int:
	return _data.size()
