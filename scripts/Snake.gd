extends SnakePart
class_name Snake

signal ate_food

export(int) var tile_size_pixels = 16
export(float) var speed_tiles_per_sec = 10
export(PackedScene) var Tail

const movement_vectors = {
    0: Vector2.RIGHT,
    1: Vector2.LEFT,
    2: Vector2.UP,
    3: Vector2.DOWN
}

# We keep track of current and next direction to avoid being able to move
# backwards by hitting buttons quickly in between movement ticks.
var current_direction: int = -1
var next_direction: int = -1

var tail = []

# Set movement direction based on unhandled input.
func _unhandled_input(_event: InputEvent) -> void:
    if Input.is_action_pressed("ui_right") and current_direction != 1:
        next_direction = 0
    elif Input.is_action_pressed("ui_left") and current_direction != 0:
        next_direction = 1
    elif Input.is_action_pressed("ui_up") and current_direction != 3:
        next_direction = 2
    elif Input.is_action_pressed("ui_down") and current_direction != 2:
        next_direction = 3

func _physics_process(delta: float) -> void:
    var weight: float = delta * speed_tiles_per_sec
    
    # If the next cell has been reached, set a new target for each node.
    var prev_tail: Area2D = null
    if position == _target_position and next_direction != -1:
        _set_new_targets()
        
    move(delta)
    
# Start a new game.
func start(pos: Vector2) -> void:
    init(pos, pos, speed_tiles_per_sec)
    show()
    
func move(delta: float) -> void:
    .move(delta)
    for tail_node in tail:
        tail_node.move(delta)
        
func _set_new_targets() -> void:
    # Calculate next movement vector.
    current_direction = next_direction
    var move: Vector2 = movement_vectors[current_direction] * tile_size_pixels
    
    # Check for a collision on the next move.
    $RayCast2D.cast_to = move * 4
    $RayCast2D.force_raycast_update()
    if $RayCast2D.is_colliding():
        var collider = $RayCast2D.get_collider()
        if collider.is_in_group("food"):
            _eat_food(collider.position)
        else:
            _game_over()
    
    # Set a new target for each piece of the snake.
    set_target(position + move)    
    var prev_tail: Area2D = null
    for tail_node in tail:
        if prev_tail == null:
            tail_node.set_target(position)
        else:
            tail_node.set_target(prev_tail.position)
        prev_tail = tail_node
    
func _game_over() -> void:
    # Set speed to 0 so the snake stops.
    _speed_tiles_per_sec = 0

func _eat_food(food_position: Vector2) -> void:
    # Create a tail node at the current location of the head and add it to
    # the scene.
    var tail_node: SnakePart = Tail.instance()
    tail_node.init(position, position, speed_tiles_per_sec)
    tail.push_front(tail_node)
    get_parent().add_child(tail_node)
    
    # Update the head to replace the location of the food.
    position = food_position
    _target_position = position
    
    # Send signal to create another food.
    emit_signal("ate_food")
