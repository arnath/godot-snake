extends Area2D
class_name SnakePart

var _original_position: Vector2
var _target_position: Vector2
var _speed_tiles_per_sec: float
var _offset: float
        
func init(pos: Vector2, target: Vector2, speed: float) -> void:
    _speed_tiles_per_sec = speed
    position = pos
    _original_position = pos
    _target_position = target
    _offset = 0

func set_target(target: Vector2) -> void:
    _original_position = position
    _target_position = target
    _offset = 0

# Move toward the target.
func move(delta: float) -> void:
    if position != _target_position:
        _offset += (delta * _speed_tiles_per_sec)
        position = lerp(_original_position, _target_position, _offset)
