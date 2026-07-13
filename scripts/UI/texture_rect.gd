extends TextureRect

@export var item : PlaceableItem
@onready var label : Label = $"../../Label"

@onready var managers := get_tree().get_first_node_in_group("Managers")
@onready var scene_manager := managers.get_node("SceneManager")


func _ready() -> void:
	# texture = item.icon
	if not EventBus.level_configured.is_connected(_texture_label_setup):
		EventBus.level_configured.connect(_texture_label_setup)
	if not PlacementManager.count_changed.is_connected(_on_count_changed):
		PlacementManager.count_changed.connect(_on_count_changed)

func _texture_label_setup() -> void:
	PlacementManager.get_remaining(item)
	
	label.text = "%s: ( %d/%d )" % [item.display_name, PlacementManager.get_remaining(item), PlacementManager.get_max(item)]

func _on_count_changed(changed_item: PlaceableItem, count: int) -> void:
	if changed_item == item and PlacementManager.get_remaining(item) <= 0:
		modulate.a = 0.5
	if changed_item == item:
		label.text = "%s: ( %d/%d )" % [item.display_name, count, PlacementManager.get_max(item)]


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		PlacementManager.start_placing(item)
		EventBus.deselect_arrow()
		get_viewport().set_input_as_handled()
