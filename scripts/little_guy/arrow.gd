extends Area2D

enum Direction  {UP, RIGHT, DOWN, LEFT}
@export var choose_dir : Direction = Direction.UP

var pointing_dir : Vector2
var is_selected : bool = false

func _ready() -> void:
	_set_dir_rotation()


func _set_dir_rotation() -> void:
	match choose_dir:
		Direction.UP:
			pointing_dir = Vector2.UP
		Direction.RIGHT:
			pointing_dir = Vector2.RIGHT
		Direction.DOWN:
			pointing_dir = Vector2.DOWN
		Direction.LEFT:
			pointing_dir = Vector2.LEFT
		_:
			pointing_dir = Vector2.UP

	rotation = pointing_dir.angle()


func rotate_right() -> void:
	var next_dir_index := (choose_dir as int + 1) % 4
	choose_dir = Direction.values()[next_dir_index]
	_set_dir_rotation()

func rotate_left() -> void: 
	var next_dir_index := (choose_dir as int - 1 + 4) % 4
	choose_dir = Direction.values()[next_dir_index]
	_set_dir_rotation()
	


func _on_body_entered(body: Node2D) -> void:
	if body is LittleGuy:
		print("player")
		print(self.rotation)
		if body.has_method("change_dir"):
			body.change_dir(pointing_dir)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		EventBus.select_arrow(self)
		get_viewport().set_input_as_handled()		

func set_selected(value: bool) -> void:
	is_selected = value
	modulate = Color.GREEN if is_selected else Color.GRAY
