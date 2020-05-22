extends Area2D
class_name Snake

enum Direction {
    RIGHT,
    LEFT,
    UP,
    DOWN
}

export(int) var tile_size_pixels = 64
export(float) var speed_tiles_per_sec = 0.1

var movementVectors = {
    0: Vector2.RIGHT,
    1: Vector2.LEFT,
    2: Vector2.UP,
    3: Vector2.DOWN
}

var direction := -1
var screen_size: Vector2

func _ready() -> void:
    screen_size = get_viewport_rect().size
    hide()

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
            
func _physics_process(_delta: float) -> void:
    if direction != -1:
        position += movementVectors[direction] * tile_size_pixels * speed_tiles_per_sec
        position.x = clamp(position.x, 0, screen_size.x)
        position.y = clamp(position.y, 0, screen_size.y)
    
# Start a new game.
func start(pos: Vector2) -> void:
    position = pos
    show()
