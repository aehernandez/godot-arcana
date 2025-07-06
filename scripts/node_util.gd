class_name NodeUtil

static func swap(a: Node, b: Node):
	var b_parent = b.get_parent()
	var a_parent = a.get_parent()
	b.reparent(a_parent)
	a.reparent(b_parent)
	
static func disconnect_all(s: Signal):
	for connection in s.get_connections():
		s.disconnect(connection.callable)
	
static func get_first_child_by_type(node: Node, type: Variant):
	for child in node.get_children():
		if is_instance_of(child, type):
			return child
	return null

static func rotate_up_to_direction(node: Node2D, direction: Vector2):
	node.look_at(node.global_position + direction)
	node.rotate(deg_to_rad(90))

static func get_all_children(parent: Node) -> Array:
	var children = []
	var waiting := parent.get_children()
	while not waiting.is_empty():
		var node := waiting.pop_back() as Node
		waiting.append_array(node.get_children())
		children.push_back(node)
	return children
