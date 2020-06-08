extends HBoxContainer
class_name HighScoreListItem

func init(key: String, value: String) -> void:
    $Key.text = key
    $Value.text = value
