extends Area2D
class_name Food

func _on_Food_area_entered(area: Area2D) -> void:
    queue_free()
