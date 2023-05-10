class_name Random

# Returns a random key in `prob_map` weighted by its associated integer value. 
# Example #1:
#   get_weighted_choice({'A': 2, 'B': 1})
#   A is twice as likely to be picked over B
#
# Example #2:
#   get_weighted_choice({'A': 2, 'B': 2})
#   A and B are equally likely to be picked
#
# Keys can be any value but values must be `int` types
static func get_weighted_choice(prob_map: Dictionary):
	var total: int = 0
	for value in prob_map.values():
		total += value

	var count: int = 0
	var target = randi_range(0, total - 1)

	for key in prob_map.keys():
		var prob: int = prob_map[key]

		var start = count
		var end = prob + count

		if target >= start and target < end:
			return key

		count += prob
		
	# unreachable
	assert(false)

# Returns a random element in sequence
# This method is deprecated, prefer using `Array.choice`
static func get_random_choice(sequence):
	assert(sequence.size() > 0)
	var total = sequence.size()
	var target = randi_range(0, total - 1)
	return sequence[target]

static func choice(sequence):
	return sequence.pick_random()

static func choices(sequence, n: int):
	assert(n > 0)
	assert(sequence.size() > 0)
	assert(n <= sequence.size())
	var samples_idx = range(sequence.size())
	samples_idx.shuffle()
	return samples_idx.slice(0, n).map(func(idx): return sequence[idx])

static func vector2(from: float, to: float) -> Vector2:
	return Vector2(
		randf_range(from, to),
		randf_range(from, to)
	)
