class_name Angle

## Returns the shortest angle between `current` to `target`. 
## Positive values indicate a clockwise rotation, while negative values indicate
## a counterclockwise rotation.
static func short_angle_distance(current: float, target: float) -> float:
    return fmod(target - current + TAU + PI, TAU) - PI