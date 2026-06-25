extends BaseAttack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

	attack_name = 'Ataque Kusarigama 1'

	damage = 5
	step = 3
	pre_step_duration = 1
	step_duration = 0.75

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func run_animation() -> void:
	sprite.visible = true
	# animation_player.play("giro-doido")
	animation_player.play("attack")
	await animation_player.animation_finished
	#await get_tree().create_timer(1.).timeout

	sprite.visible = false
	attack_finished.emit()
