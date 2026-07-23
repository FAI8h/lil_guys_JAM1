extends Node
class_name GameManager

@onready var managers := get_parent()
@onready var scene_manager := managers.get_node("SceneManager")
@onready var spawn_manager := managers.get_node("SpawnManager")
@onready var level_timer : Timer = $LevelTimer
#dev only
@export var skip_to_lvl : int = 1
@export var skip : bool = false
var is_paused : bool = false

func _ready() -> void:
	call_deferred("_start_game")
	EventBus.lil_died.connect(restart_level)
	EventBus.level_completed.connect(update_level)
	EventBus.pause_changed.connect(_toggle_pause)

func _process(_delta: float) -> void:
	if level_timer.time_left > 0:
		EventBus.time_updated.emit(level_timer.time_left)
	
	

func start_level_timer(duration : float) ->void:
	if duration <= 0:
		return
	level_timer.wait_time = duration
	level_timer.one_shot = true
	level_timer.start()
	print("timer started : ",level_timer.time_left)


func stop_level_timer() -> void:
	level_timer.stop()

func _on_level_timer_timeout() -> void:
	_stop_game()
	EventBus.level_time_up.emit()

func _start_game()-> void:
	if not skip:
		scene_manager.load_level(1)
	else:
		scene_manager.load_level(skip_to_lvl)

func _stop_game() -> void:
	stop_level_timer()
	spawn_manager.stop_spawning()




func update_level() -> void:
	scene_manager.load_level(scene_manager.current_level_id + 1)

func restart_level(reason : String) -> void:
	print(reason)
	scene_manager.restart_level()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pause()
		

func _toggle_pause() -> void:
	is_paused = not is_paused
	EventBus.pause_changed.emit(is_paused)
	get_tree().paused = is_paused
