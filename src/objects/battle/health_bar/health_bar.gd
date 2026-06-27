class_name HealthBar extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar

var health_component: HealthComponent

@export var color: Color

func _ready() -> void:
	set_color()

func set_color() -> void:
	var style: StyleBoxFlat = (progress_bar.get_theme_stylebox("fill").duplicate() as StyleBoxFlat)
	style.bg_color = color
	progress_bar.add_theme_stylebox_override("fill", style)

func set_health_component(value: HealthComponent) -> void:
	health_component = value
	progress_bar.max_value = health_component.max_health
	progress_bar.value = health_component.current_health
	progress_bar.step = 0.01

func _process(_delta: float) -> void:
	if health_component and health_component.updated:
		progress_bar.value = health_component.current_health
		health_component.aplied_update()
