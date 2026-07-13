extends Area2D

var total_exit : int
var max_unit : int

func _ready() -> void:
    EventBus.max_unit.connect(_set_max_unit)


func _set_max_unit(count : int) -> void:
    print("setting max unit")
    max_unit = count
    total_exit = 1


func _on_body_entered(body: Node2D) -> void:
    if body is LittleGuy:
        print("total unit count : ", max_unit, " \n max exit : ", total_exit)
        if total_exit == max_unit:
            EventBus.level_completed.emit()
            print("level_completed... : ")
        total_exit += 1
        body.queue_free()
