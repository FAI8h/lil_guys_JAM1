extends Control

@onready var timer_label : Label = $Panel/Label

func _ready() -> void:
    EventBus.time_updated.connect(_update_timer_label)

    
func _update_timer_label(seconds : float) -> void:
    timer_label.text =  "time left : " + "%.1fs" % seconds