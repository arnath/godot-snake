extends Area2D
class_name Snake

enum Direction {
    RIGHT,
    LEFT,
    UP,
    DOWN
}

export(int) var tile_size_pixels = 16
export(float) var speed_tiles_per_sec = 20

var movementVectors = {
    0: Vector2.RIGHT,
    1: Vector2.LEFT,
    2: Vector2.UP,
    3: Vector2.DOWN
}

var direction = -1
var originalPosition: Vector2
var targetPosition: Vector2
var offset: float = 0

# Set movement direction based on unhandled input.
func _unhandled_input(_event: InputEvent) -> void:
    if Input.is_action_pressed("ui_right") and direction != 1:
        direction = 0
    elif Input.is_action_pressed("ui_left") and direction != 0:
        direction = 1
    elif Input.is_action_pressed("ui_up") and direction != 3:
        direction = 2
    elif Input.is_action_pressed("ui_down") and direction != 2:
        direction = 3

func _physics_process(delta: float) -> void:
    var weight = delta * speed_tiles_per_sec
    
    # If the next cell has been reached, set a new target.
    if position == targetPosition and direction != -1:
        originalPosition = position
        targetPosition = position + (movementVectors[direction] * tile_size_pixels)
        offset = 0
        
    # Move toward the target.
    if position != targetPosition:
        offset += weight
        position = lerp(originalPosition, targetPosition, offset)
    
# Start a new game.
func start(pos: Vector2) -> void:
    position = pos
    targetPosition = pos
    show()
