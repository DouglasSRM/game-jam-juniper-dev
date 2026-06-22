class_name PlayerFrame extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("falano")

func pause_animation() -> void:
	animation_player.stop()

func resume_animation() -> void:
	animation_player.play("falano")
