extends CharacterBody2D

class_name LittleGuy

var spawn_point : Marker2D
var death_area : Area2D

var speed : float = 100.0
var move_dir : Vector2

func _ready() -> void:

	call_deferred("_init_area")


func _process(_delta: float) -> void:
	if move_dir:
		velocity = move_dir * speed

	move_and_slide()

func _init_area() -> void:
	death_area = get_tree().get_first_node_in_group("Death")
	spawn_point = get_tree().get_first_node_in_group("Spawn")
	move_dir = (death_area.global_position - spawn_point.global_position).normalized()


func change_dir(new_dir : Vector2) -> void:
	move_dir = new_dir


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	EventBus.lil_died.emit("Out of Arena")
	die()


func die() -> void:
	queue_free()

func apply_boost(multiplier : float) -> void:
	speed *= multiplier

