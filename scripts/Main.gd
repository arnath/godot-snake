extends Node

func _ready() -> void:
    new_game()

func new_game() -> void:
    $Snake.start($StartPosition.position)
