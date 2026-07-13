class_name SpawnManager
extends Node2D


var scene_to_spawn : PackedScene = preload("uid://b2xptwx5rxvkh")

var lil_sp : Marker2D
var spawn_timer : Timer
var spawn_interval : float = 1.0 :
	set(value):
		spawn_interval = value
		if spawn_timer:
			spawn_timer.wait_time = value 
var max_unit_spawn : int = 0
var total_spawned_unit : int = 0
@onready var managers := get_parent()
@onready var scene_manager := managers.get_node("SceneManager")


func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timeout)
	add_child(spawn_timer)

func set_spawn_point(marker: Marker2D) -> void:
	lil_sp = marker

func start_spawning() -> void:
	total_spawned_unit = 0
	if not lil_sp:
		push_warning("SpawnManager: no spawn point set before starting spawn timer")
		return
	spawn_timer.start()


func stop_spawning() -> void:
	spawn_timer.stop()


func _on_spawn_timeout() -> void:
	if total_spawned_unit >= max_unit_spawn:
		spawn_timer.stop()
		return
	request_spawn(scene_to_spawn)

func request_spawn(scene : PackedScene) -> void:
	var new_scene := scene.instantiate()
	new_scene.global_position = lil_sp.global_position
	get_tree().get_first_node_in_group("Units").add_child(new_scene)
	total_spawned_unit += 1
