extends Node

export(PackedScene) var Food

func _ready() -> void:
    randomize()
    new_game()

func new_game() -> void:
    $Snake.start($StartPosition.position)
    _spawn_food()
    
func _spawn_food() -> void:
    # Pick a random position for the next food and make sure it doesn't collide
    # with the snake head.
    var food_position: Vector2 = $Snake.position
    while food_position == $Snake.position:
        food_position = Vector2((randi() % 80) * 16 + 8, (randi() % 45) * 16 + 8)
        
    # Add the food to the scene.
    var food: Food = Food.instance()
    food.position = food_position
    add_child(food)
