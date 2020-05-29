extends SnakePart
class_name Snake

signal ate_food

export(int) var tile_size_pixels = 16
export(float) var speed_tiles_per_sec = 15
export(PackedScene) var Tail

const movementVectors = {
    0: Vector2.RIGHT,
    1: Vector2.LEFT,
    2: Vector2.UP,
    3: Vector2.DOWN
}

var direction: int = -1
var tail = []

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
    var weight: float = delta * speed_tiles_per_sec
    
    # If the next cell has been reached, set a new target for each node.
    var prev_tail: Area2D = null
    if position == _target_position and direction != -1:
        set_target(position + movementVectors[direction] * tile_size_pixels)
        for tail_node in tail:
            if prev_tail == null:
                tail_node.set_target(position)
            else:
                tail_node.set_target(prev_tail.position)
            prev_tail = tail_node
        
    move(delta)
    
# Start a new game.
func start(pos: Vector2) -> void:
    init(pos, pos, speed_tiles_per_sec)
    show()
    
func game_over() -> void:
    # Set speed to 0 so the snake stops.
    _speed_tiles_per_sec = 0

func _on_Snake_area_entered(area: Area2D) -> void:
    if area.is_in_group("food"):
        # Create a tail node at the current location of the head and add it to
        # the scene.
        var tail_node: SnakePart = Tail.instance()
        tail_node.init(_original_position, _target_position, speed_tiles_per_sec)
        tail.push_front(tail_node)
        get_parent().add_child(tail_node)
        
        # Update the head to replace the location of the food.
        position = area.position
        _target_position = position
        
        # Send signal to create another food.
        emit_signal("ate_food")
    elif area.is_in_group("tail"):
        if len(tail) != 0 && area != tail[0]:
            print("collided with tail")
            game_over()

func _on_Snake_body_entered(body):
    print("collided with wall")
    game_over()
