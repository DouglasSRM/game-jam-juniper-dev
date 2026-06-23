class_name HealthComponent extends Node

var max_health: float = 0.
var current_health: float = 0.
var updated: bool = false

func set_health(value: float) -> void:
	current_health = value
	updated = true

func aplied_update() -> void:
	updated = false
