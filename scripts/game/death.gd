extends Area2D


#! Fixing Game over and game complete 

func _on_body_entered(body: Node2D) -> void:
    if body is LittleGuy:
        body.queue_free()
        EventBus.lil_died.emit("fall into pit")
      
