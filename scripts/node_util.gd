class_name NodeUtil

static func swap(a: Node, b: Node):
	var b_parent = b.get_parent()
	var a_parent = a.get_parent()
	b.reparent(a_parent)
	a.reparent(b_parent)
	
static func disconnect_all(s: Signal):
	for connection in s.get_connections():
		s.disconnect(connection.callable)
	
