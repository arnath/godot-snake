extends Panel
class_name HUD

signal start_game

export(PackedScene) var HighScoreListItem

const HIGH_SCORES_FILE: String = "user://high_scores.dat"
const MAX_HIGH_SCORES: int = 5

# _high_scores is an object of the form below with a max of 5 scores.
# {
#   "scores":
#   [
#       { "player": player_name, "score": score },
#       ...
#   ]  
# }
var _high_scores

var game_over_score: int

func _ready() -> void:
    $MarginContainer/DefaultInterface/HighScoreList/PlayerScoreListItem.init("Player", "Score")
    $MarginContainer/DefaultInterface/HighScoreList/DashListItem.init("----------", "----------")
    _show_default_ui()
    
func game_over(score: int) -> void:
    var new_high_score: bool = false
    if len(_high_scores) < MAX_HIGH_SCORES:
        new_high_score = true
    else:
        for player_score in _high_scores:
            if score > player_score.score:
                new_high_score = true
                break
    
    if new_high_score:
        game_over_score = score
        _show_high_score_input()
    else:
        _show_default_ui()

func _show_default_ui() -> void:
    _load_high_scores()

    # Empty high score list.
    var children: Array = $MarginContainer/DefaultInterface/HighScoreList.get_children()
    var num_children = len(children)
    for i in range(2, num_children):
        children[i].queue_free()

    # Add in new high score items.
    for player_score in _high_scores:
        var list_item: HighScoreListItem = HighScoreListItem.instance()
        list_item.init(player_score.player, str(player_score.score))
        $MarginContainer/DefaultInterface/HighScoreList.add_child(list_item)       
        
    $MarginContainer/HighScoreInput.hide()
    $MarginContainer/DefaultInterface.show()
    
func _show_high_score_input() -> void:
    $MarginContainer/DefaultInterface.hide()
    $MarginContainer/HighScoreInput.show()
        
func _load_high_scores() -> void:
    # Load high scores from file.
    var file: File = File.new()
    file.open(HIGH_SCORES_FILE, File.READ)
    _high_scores = file.get_var()
    if _high_scores == null:
        _high_scores = [ ]
        
func _save_high_scores() -> void:
    var file: File = File.new()
    var mode_flags = File.WRITE_READ
    if !file.file_exists(HIGH_SCORES_FILE):
        # Allow creation and truncation of the file if it doesn't exist.
        mode_flags = File.WRITE_READ
        
    file.open(HIGH_SCORES_FILE, mode_flags)
    file.store_var(_high_scores)  

func _on_EasyButton_pressed() -> void:
    emit_signal("start_game", 5)

func _on_NormalButton_pressed():
    emit_signal("start_game", 10)

func _on_HardButton_pressed():
    emit_signal("start_game", 15)

func _on_SubmitButton_pressed():
    var new_score = { "player": $MarginContainer/HighScoreInput/InputLineEdit.text, "score": game_over_score }
    var high_score_length: int = len(_high_scores)
    
    # Update and save high score.
    for i in high_score_length:
        if new_score.score > _high_scores[i].score:
            var temp = _high_scores[i]
            _high_scores[i] = new_score
            new_score = temp
            
    if high_score_length < MAX_HIGH_SCORES:
        _high_scores.append(new_score)
        
    _save_high_scores()
    _show_default_ui()
    
func _on_SkipButton_pressed():
    _show_default_ui()
