extends BaseAttack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

	attack_name = 'Ataque Chakram 1'

	damage = 5
	step = 7
	pre_step_duration = 0.5
	step_duration = 0.5

func run_animation() -> void:
	sprite.visible = true
	animation_player.play("attack")
	await animation_player.animation_finished

	attack_finished.emit()
	sprite.visible = false
