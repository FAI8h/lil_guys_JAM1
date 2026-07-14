extends Control

@onready var main_menu_buttons : VBoxContainer = $MainButtons/VBoxContainer
@onready var settings : Panel = $Options

func _ready() -> void:
    main_menu_buttons.visible = true
    settings.visible = false

func _on_settings_pressed() -> void:
    print("Settings Pressed ...")
    main_menu_buttons.visible = false
    settings.visible = true


func _on_back_pressed() -> void:
    _ready()


func _on_full_screen_toggled(toggled_on: bool) -> void:
    if toggled_on == true:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

