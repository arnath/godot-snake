extends Node

export(PackedScene) var Snake
export(PackedScene) var Food

var score: int

var _snake: Snake
var _food: Food

func _ready() -> void:
    randomize()
    $HUDLayer/HUD.show()

func start_game(speed_tiles_per_sec: float):
    _set_score(0)
    _spawn_snake(speed_tiles_per_sec)
    _spawn_food()
    $HUDLayer/HUD.hide()
    
func game_over():
    # Despawn the last food.
    if _food != null:
        _food.queue_free()
        _food = null
        
    # The snake is the source of the game over signal so it handles
    # free-ing itself.
    _snake = null
        
    $HUDLayer/HUD.game_over(score)
    $HUDLayer/HUD.show()

func _spawn_snake(speed_tiles_per_sec: float) -> void:
    _snake = Snake.instance()
    _snake.connect("ate_food", self, "_on_Snake_ate_food")
    _snake.connect("game_over", self, "game_over")
    _snake.init($StartPosition.position, $StartPosition.position, speed_tiles_per_sec)
    add_child(_snake)

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
    
func _set_score(new_score: int) -> void:
    score = new_score
    $ScoreNumber.text = str(score)

func _on_Snake_ate_food() -> void:
    _set_score(score + 1)
    _spawn_food()
