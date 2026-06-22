class_name BaseAttack extends Node2D

@onready var sprite: Sprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal attack_finished

var pre_step_duration: float = 0
var step_duration: float = 0
var step: int = 0

var damage: int = 0

var target: Entity

func _ready() -> void:
	sprite.visible = false

func run_animation() -> void:
	await Utils.sleep(1)
	pass

func execute() -> void:
	run_animation()
	
	await Utils.sleep(pre_step_duration)
	var step_damage = damage / step
	
	for i in range(1, step+1):
		if i == step:
			var difference = damage - (step_damage * step)
			step_damage += difference
		target.take_damage(step_damage)
		await Utils.sleep(step_duration)
