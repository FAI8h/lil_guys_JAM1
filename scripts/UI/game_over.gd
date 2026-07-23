extends Control

@export var game_manager : GameManager
@export var scene_manager : SceneManager

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	position.x = 0
	position.y = 0
	EventBus.level_time_up.connect(_on_level_time_up)
	pass

func _on_level_time_up() -> void:
	get_tree().paused = true
	visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_retry_pressed() -> void:
	get_tree().paused = false
	visible = false
	game_manager.restart_level("retrying")
	pass # Replace with function body.


func _on_main_menu_pressed() -> void:
	pass # Replace with function body.
