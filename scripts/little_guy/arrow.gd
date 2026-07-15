extends Area2D

enum Direction  {UP, RIGHT, DOWN, LEFT}
@export var choose_dir : Direction = Direction.UP

var boost_chance : float
var boost_multiplier : float
var is_boost : bool = false

var pointing_dir : Vector2
var is_selected : bool = false

func _ready() -> void:
	EventBus.level_stats.connect(set_boost_value)
	_set_dir_rotation()

func set_boost_value(chance : float = 0.2, multiplier : float = 1.5) ->void:
	boost_chance = chance
	boost_multiplier = multiplier

func rool_boost() -> void:
	is_boost = randf() < boost_chance
	if is_boost:
		modulate = Color(1.0, 0.8, 0.2)


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
		print(self.rotation)
		if body.has_method("change_dir"):
			body.change_dir(pointing_dir)
		if is_boost and body.has_method("apply_boost"):
			body.apply_boost(boost_multiplier)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		EventBus.select_arrow(self)
		get_viewport().set_input_as_handled()		

func set_selected(value: bool) -> void:
	is_selected = value
	if is_selected:
		modulate = Color.GREEN
	else:
		if is_boost:
			modulate = Color(1.0, 0.8, 0.2)
		else:
			modulate = Color.WHITE

