extends Area2D
class_name SnakePart

# Speed of the snake part in tiles per sec.
var _speed_tiles_per_sec: float

# Original position of the snake part.
var _original_position: Vector2

# Target position of the snake part. The snake linear interpolates between
# the original and target positions while moving.
var _target_position: Vector2

# Offset of the snake part in between the original and target positions.
# It is used for the linear interpolation.
var _offset: float

# Initialize a snake part.
func init(pos: Vector2, speed: float) -> void:
    _speed_tiles_per_sec = speed
    position = pos
    _original_position = pos
    _target_position = pos
    _offset = 0

# Set a new target position.
func set_target(target: Vector2) -> void:
    _original_position = position
    _target_position = target
    _offset = 0

# Move toward the target position.
func move(delta: float) -> void:
    if position != _target_position:
        _offset += (delta * _speed_tiles_per_sec)
        position = lerp(_original_position, _target_position, _offset)
