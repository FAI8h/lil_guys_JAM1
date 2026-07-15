extends Node

signal level_configured
signal lil_died(reason: String)
signal level_completed
signal max_unit(unit : int)
signal pause_changed(pause : bool)

signal level_time_up
signal time_updated(seconds : float)
signal level_stats(chance : float, multiplier : float)

var selected_arrow : Area2D

func select_arrow(arrow :Area2D) -> void:
    if selected_arrow == arrow:
        return
    if selected_arrow and selected_arrow.has_method("set_selected"):
        selected_arrow.set_selected(false)

    selected_arrow = arrow
    if selected_arrow and selected_arrow.has_method("set_selected"):
        selected_arrow.set_selected(true)



func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        deselect_arrow()
    elif event.is_action_pressed("rotate_right"):
        if selected_arrow:
            selected_arrow.rotate_right()
    elif event.is_action_pressed("rotate_left"):
        if selected_arrow:
            selected_arrow.rotate_left()

func deselect_arrow() -> void:
    if selected_arrow and selected_arrow.has_method("set_selected"):
        selected_arrow.set_selected(false)
    selected_arrow = null