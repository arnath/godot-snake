extends Node

export(PackedScene) var Snake
export(PackedScene) var Food

# Current score of the current game.
var _score: int

# The snake head instance for the current game.
var _snake: Snake

# The last food instance spawned.
var _food: Food

func _ready() -> void:
    randomize()
    $HUDLayer/HUD.show()

# Start a new game.
func start_game(speed_tiles_per_sec: float):
    _set_score(0)
    _spawn_snake(speed_tiles_per_sec)
    _spawn_food()
    $HUDLayer/HUD.hide()

# Handle game over.
func game_over():
    # Despawn the last food.
    if _food != null:
        _food.queue_free()
        _food = null
        
    # The snake is the source of the game over signal so it handles
    # free-ing itself.
    _snake = null
        
    $HUDLayer/HUD.game_over(_score)
    $HUDLayer/HUD.show()

# Spawn a new snake head instance.
func _spawn_snake(speed_tiles_per_sec: float) -> void:
    _snake = Snake.instance()
    _snake.connect("ate_food", self, "_on_Snake_ate_food")
    _snake.connect("game_over", self, "game_over")
    _snake.init($StartPosition.position, speed_tiles_per_sec)
    add_child(_snake)

# Spawn a new food at a random position.
func _spawn_food() -> void:
    # Pick a random position for the next food and make sure it doesn't collide
    # with the snake head.
    var food_position: Vector2 = _snake.position
    while food_position == _snake.position:
        food_position = Vector2((randi() % 38) * 16 + 24, (randi() % 38) * 16 + 24)
        
    # Add the food to the scene.
    _food = Food.instance()
    _food.position = food_position
    add_child(_food)

# Event handler for the ate_food signal from the snake.
func _on_Snake_ate_food() -> void:
    _set_score(_score + 1)
    _spawn_food()

# Sets the current score and updates the score label.
func _set_score(new_score: int) -> void:
    _score = new_score
    $ScoreNumber.text = str(_score)
