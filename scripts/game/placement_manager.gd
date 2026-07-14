extends Node

signal count_changed(item : PlaceableItem, count: int)

var remaining_counts : Dictionary = {}
var max_counts : Dictionary = {}
var is_placing : bool = false
var current_item : PlaceableItem = null
var ghost_instance : Node2D = null

func register_item(item : PlaceableItem, max_count : int) -> void:
	max_counts[item] = max_count
	remaining_counts[item] = max_count

func get_remaining(item : PlaceableItem) -> int:
	return remaining_counts.get(item, 0)

func get_max(item : PlaceableItem) -> int:
	return max_counts.get(item,0)


func start_placing(item : PlaceableItem) -> void:
	print("start_placing called, remaining: ", get_remaining(item))
	if get_remaining(item) <= 0:
		return
	is_placing = true
	current_item = item
	ghost_instance = item.scene.instantiate()
	ghost_instance.modulate.a = 0.5

	if ghost_instance is Area2D:
		ghost_instance.collision_layer = 0
		ghost_instance.collision_mask = 0
		ghost_instance.input_pickable = false
	get_tree().get_first_node_in_group("Objects").add_child(ghost_instance)


func _process(_delta: float) -> void:
	if is_placing and ghost_instance:
		ghost_instance.global_position = get_viewport().get_mouse_position()


func confirm_placing() -> void:
	# print("CONFIRM CALLED, is_placing was: ", is_placing)
	if not is_placing:
		return
	ghost_instance.modulate.a = 1.0
	if ghost_instance is Area2D:
		ghost_instance.collision_layer = 2
		ghost_instance.collision_mask = 1
		ghost_instance.input_pickable = true

	if ghost_instance.has_method("rool_boost"):
		print("rolling boost")
		ghost_instance.rool_boost()

	remaining_counts[current_item] -= 1
	count_changed.emit(current_item, remaining_counts[current_item])
	is_placing = false
	ghost_instance = null
	current_item = null

func cancel_placement() -> void:
	if ghost_instance:
		ghost_instance.queue_free()
	ghost_instance = null
	is_placing = false
	current_item = null


func _unhandled_input(event: InputEvent) -> void:
	
	if not is_placing:
		return
	
	# print("PlacementManager unhandled_input saw: ", event)
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			confirm_placing()
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			cancel_placement()
			get_viewport().set_input_as_handled()
	
	elif event.is_action_pressed("ui_cancel"):
		cancel_placement()


func clear_all() -> void:
	cancel_placement()
	remaining_counts.clear()
	max_counts.clear()
