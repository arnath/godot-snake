extends Area2D
class_name SnakePart

var _original_position: Vector2
var _target_position: Vector2
var _speed_tiles_per_sec: float
var _offset: float

func _physics_process(delta: float) -> void:
    # Move toward the target.
    if position != _target_position:
        _offset += (delta * _speed_tiles_per_sec)
        position = lerp(_original_position, _target_position, _offset)

func set_target(target: Vector2, speed: float) -> void:
    _original_position = position
    _target_position = target
    _offset = 0
    _speed_tiles_per_sec = speed
