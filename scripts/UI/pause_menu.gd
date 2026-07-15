extends Control
@export var game_manager : GameManager
var is_paused : bool  

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	EventBus.pause_changed.connect(_on_pause_changed)

func _on_pause_changed(paused: bool) -> void:
	visible = paused


func _on_resume_pressed() -> void:
	if game_manager:
		game_manager._toggle_pause()


func _on_restart_pressed() -> void:
	visible = false
	if game_manager:
		game_manager._toggle_pause()
	
		game_manager.restart_level("restart")


func _on_main_menu_pressed() -> void:
	game_manager._toggle_pause()
	get_tree().change_scene_to_file("res://scenes/game/main_menu.tscn")
