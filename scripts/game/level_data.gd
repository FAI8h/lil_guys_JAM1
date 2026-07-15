#level.tres data --> level data

class_name LevelDate
extends Resource

@export var max_unit_spawn : int = 3
@export var spawn_interval : float = 1.0
@export var time_limit : float = 10.0
@export var boost_multiplier : float = 1.5
@export var boost_chance : float = 0.2
@export var placeablea_allowance : Array[PlaceableAllowance] = []
