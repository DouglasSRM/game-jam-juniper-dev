extends BaseAttack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

	attack_name = 'Ataque Chakram 2'

	damage = 5
	step = 3
	pre_step_duration = 1
	step_duration = 0.75

func run_animation() -> void:
	sprite.visible = true
	animation_player.play("attack")
	await animation_player.animation_finished

	attack_finished.emit()
	sprite.visible = false
