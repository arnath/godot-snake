extends SnakePart
class_name Snake

signal ate_food
signal game_over

const MOVEMENT_VECTORS = {
    0: Vector2.RIGHT,
    1: Vector2.LEFT,
    2: Vector2.UP,
    3: Vector2.DOWN,
}

export(int) var tile_size_pixels = 16
export(PackedScene) var Tail

# We keep track of current and next direction to avoid being able to move
# backwards by hitting buttons quickly in between movement ticks.
var _current_direction: int = -1
var _next_direction: int = -1

# List of tail nodes, each an instance of the Tail scene.
var tail: Array = []

func _physics_process(delta: float) -> void:
    # Handle input to set future direction.
    _set_next_direction()
    
    # If the next cell has been reached, set a new target for each node.
    var weight: float = delta * _speed_tiles_per_sec
    var prev_tail: Area2D = null
    if position == _target_position and _next_direction != -1:
        _set_new_targets()
        
    move(delta)

# Move the head and all tail nodes toward the target position.
func move(delta: float) -> void:
    .move(delta)
    for tail_node in tail:
        tail_node.move(delta)

# Set next direction based on input.        
func _set_next_direction() -> void:
    if Input.is_action_pressed("ui_right") and _current_direction != 1:
        _next_direction = 0
    elif Input.is_action_pressed("ui_left") and _current_direction != 0:
        _next_direction = 1
    elif Input.is_action_pressed("ui_up") and _current_direction != 3:
        _next_direction = 2
    elif Input.is_action_pressed("ui_down") and _current_direction != 2:
        _next_direction = 3
        
# Set new target positions for head and all tail nodes.
func _set_new_targets() -> void:
    # Calculate next movement vector.
    _current_direction = _next_direction
    var move: Vector2 = MOVEMENT_VECTORS[_current_direction] * tile_size_pixels
    
    # Check for a collision on the next move.
    $RayCast2D.cast_to = move * 4
    $RayCast2D.force_raycast_update()
    
    if $RayCast2D.is_colliding():
        var collider: Node2D = $RayCast2D.get_collider()
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

# Eat food and create a new tail node.
func _eat_food(food_position: Vector2) -> void:
    # Create a tail node at the current location of the head and add it to
    # the scene.
    var tail_node: SnakePart = Tail.instance()
    tail_node.init(position, _speed_tiles_per_sec)
    tail.push_front(tail_node)
    get_parent().add_child(tail_node)
    
    # Update the head to replace the location of the food.
    position = food_position
    _target_position = position
    
    # Send signal to create another food.
    emit_signal("ate_food")

# End the game.   
func _game_over() -> void:
    # Signal game over.
    emit_signal("game_over")
    
    # Free all tail nodes.
    for tail_node in tail:
        tail_node.queue_free()
        
    queue_free()
