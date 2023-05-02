class_name Find    

static func nearest(from: Vector2, objects: Array) -> Node2D:
	var nearest_distance := INF
	var nearest_node: Node2D = null

	for node in objects:
		assert(node is Node2D)
		var distance = node.global_position.distance_squared_to(from)
		if distance < nearest_distance:
			nearest_node = node
			nearest_distance = distance

	return nearest_node

static func get_all_children(parent: Node) -> Array:
	var children = []
	var waiting := parent.get_children()
	while not waiting.is_empty():
		var node := waiting.pop_back() as Node
		waiting.append_array(node.get_children())
		children.push_back(node)
	return children