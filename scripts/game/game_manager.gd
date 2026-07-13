extends Node

@onready var managers := get_parent()
@onready var scene_manager := managers.get_node("SceneManager")

func _ready() -> void:
	call_deferred("_start_game")
	EventBus.lil_died.connect(restart_level)
	EventBus.level_completed.connect(update_level)

func _start_game()-> void:
	scene_manager.load_level(1)

func update_level() -> void:
	scene_manager.load_level(scene_manager.current_level_id + 1)

func restart_level(reason : String) -> void:
	print(reason)
	scene_manager.restart_level()
