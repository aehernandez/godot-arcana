class_name HealthManager

signal on_health_zero
signal on_health_full
signal on_health_loss(manager: HealthManager)
signal on_health_change(manager: HealthManager)

@export var max_health := 100
@export var health := 100 :
	get:
		return health
	set(new_health):
		var old_health = health
		health = new_health
		if health > max_health:
			health = max_health
		elif health < 0:
			health = 0

		emit_signal("on_health_change", self)
		if health < old_health:
			emit_signal("on_health_loss", self)

		if health == 0:
			emit_signal("on_health_zero")
		elif health == max_health:
			emit_signal("on_health_full")

func _init(set_max_health := 100, full = true):
	max_health = set_max_health
	if full:
		health = max_health
	else:
		health = 0
