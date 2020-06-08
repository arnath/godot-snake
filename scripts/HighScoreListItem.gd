extends HBoxContainer
class_name HighScoreListItem

# Initialize a high score list item.
func init(key: String, value: String) -> void:
    $Key.text = key
    $Value.text = value
