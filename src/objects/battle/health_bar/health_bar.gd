class_name HealthBar extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar

var health_component: HealthComponent

func set_health_component(value: HealthComponent) -> void:
	health_component = value
	progress_bar.max_value = health_component.max_health
	progress_bar.value = health_component.current_health
	progress_bar.step = 1

func _process(_delta: float) -> void:
	if health_component and health_component.updated:
		progress_bar.value = health_component.current_health
		health_component.aplied_update()
