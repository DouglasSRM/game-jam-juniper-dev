extends BaseAttack

func _ready() -> void:
	super()

	attack_name = 'Attack Kusarigama 2'

	damage = 6
	step = 3
	pre_step_duration = 1
	step_duration = 0.75

func run_animation() -> void:
	sprite.visible = true
	animation_player.play("attack")
	await animation_player.animation_finished

	attack_finished.emit()
	sprite.visible = false
