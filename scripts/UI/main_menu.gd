extends Control

@onready var main_menu_buttons : VBoxContainer = $MainButtons/VBoxContainer
@onready var settings : Panel = $Options

var audio_bus_idx : int

func _ready() -> void:
    main_menu_buttons.visible = true
    settings.visible = false
    audio_bus_idx = AudioServer.get_bus_index("Music")


func _on_settings_pressed() -> void:
    main_menu_buttons.visible = false
    settings.visible = true


func _on_back_pressed() -> void:
    _ready()


func _on_full_screen_toggled(toggled_on: bool) -> void:
    if toggled_on == true:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)



func _on_h_slider_value_changed(value: float) -> void:
    print("value : ", value)
    var db := linear_to_db(value)
    AudioServer.set_bus_volume_db(audio_bus_idx, db)


func _on_start_pressed() -> void:
    Transition.fade_out()
    get_tree().change_scene_to_file("res://scenes/game/game_world.tscn")
    Transition.fade_in(0.6)

func _on_exit_pressed() -> void:
    get_tree().quit()
