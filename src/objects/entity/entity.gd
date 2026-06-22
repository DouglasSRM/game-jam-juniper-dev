class_name Entity extends Node2D

@export var max_health: int = 0

var current_health: int = 0

var health_component: HealthComponent

signal is_dead

func take_damage(value: int) -> void:
	var new_health = current_health - value
	set_health(new_health)

func _ready() -> void:
	health_component = HealthComponent.new()
	health_component.max_health = max_health
	set_health(max_health)

func set_health(value: int) -> void:
	health_component.set_health(value)
	current_health = health_component.current_health
	if current_health <= 0:
		is_dead.emit()
