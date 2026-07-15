extends Control
@export var game_manager : GameManager
var is_paused : bool  

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	EventBus.pause_changed.connect(_on_pause_changed)

func _on_pause_changed(paused: bool) -> void:
	visible = paused

func _on_resume_button_pressed() -> void:
	EventBus.pause_changed.emit()

func _on_resume_pressed() -> void:
	print("tree_paused")


func _on_restart_pressed() -> void:
	print("restart pressed")
