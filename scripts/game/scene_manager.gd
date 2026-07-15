class_name SceneManager

extends Node

@export var levels_node : Node2D
@export var spawn_manager : SpawnManager
@export var game_manager : GameManager

@export var transition : CanvasLayer

var current_level : Node2D
var current_level_id : int

const GAME_OVER_SCENE : String = "res://scenes/game/game_over.tscn"
const PAUSE_MENU : String = "res://scenes/game/pause_menu.tscn"

func _ready() -> void:
	EventBus.pause_changed.connect(_on_pause_change)


const LEVELS = {
	1: "res://scenes/game/lvl_1.tscn",
	2: "res://scenes/game/lvl_2.tscn",
	3: "res://scenes/game/lvl_3.tscn",
	4: "res://scenes/game/lvl_4.tscn",
}

const LEVEL_DATA = {
	1: "res://assets/resources/lvl_1.tres",
	2: "res://assets/resources/lvl_2.tres",
	3: "res://assets/resources/lvl_3.tres",
	4: "res://assets/resources/lvl_4.tres",
}

func load_level(id : int) -> void:
	call_deferred("_do_load_level",id)

func _do_load_level(id : int) -> void:
	await Transition.fade_out()
	_clear_previous_level()
	current_level_id = id
	
	var packed := load(LEVELS[id]) as PackedScene
	current_level = packed.instantiate()
	levels_node.add_child(current_level)

	var level_data := load(LEVEL_DATA[id]) as LevelDate
	_configure_level(level_data)
	
	await Transition.fade_in()

func _clear_previous_level() -> void:
	if current_level:
		current_level.queue_free()
		current_level = null
		current_level_id = -1
	
	for unit in get_tree().get_first_node_in_group("Objects").get_children():
		unit.queue_free()
	
	for unit in get_tree().get_first_node_in_group("Units").get_children():
		unit.queue_free()
	
	PlacementManager.clear_all()

	if spawn_manager:
		spawn_manager.stop_spawning()

func _configure_level(level_data : LevelDate) -> void:
	for allowance in level_data.placeablea_allowance:
		PlacementManager.register_item(allowance.item, allowance.max_arrow)
	PlacementManager.set_level_boost_stats(level_data.boost_chance, level_data.boost_multiplier)
	if spawn_manager:
		var spawn_marker := current_level.get_node("Spawn")
		spawn_manager.set_spawn_point(spawn_marker)
		spawn_manager.max_unit_spawn = level_data.max_unit_spawn
		spawn_manager.spawn_interval = level_data.spawn_interval
		spawn_manager.start_spawning()
	
	if game_manager:
		game_manager.start_level_timer(level_data.time_limit)

		#exit
	call_deferred("_emit_max_unit",level_data.max_unit_spawn)
	EventBus.level_configured.emit()

func _emit_max_unit(count : int) -> void:
	EventBus.max_unit.emit(count)

func restart_level() -> void:
	if current_level_id == -1:
		push_warning("SceneManager: no level currently loaded to restart")
		return
	load_level(current_level_id)

func _on_game_over(_won : bool) -> void:
	await Transition.fade_out()

func _on_pause_change(pause : bool) -> void:
	if pause:
		await Transition.fade_out()
		get_tree().paused = true
		get_tree().change_scene_to_file(PAUSE_MENU)
		Transition.fade_in()
	else:
		await Transition.fade_out()
		get_tree().paused = false
		Transition.fade_in()
	
		
