extends BaseAttack


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	var parent_weapon = get_parent() # AQui na real a gente pode setar os danos por atauque
	if parent_weapon:
		await parent_weapon.ready

		if parent_weapon is BaseWeapon:
			self.damage = parent_weapon.damage
			print("BCT DAN: ", self.damage)

	step = 1
	pre_step_duration = .2
	step_duration = .5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func run_animation() -> void:
	sprite.visible = true
	# animation_player.play("giro-doido")
	animation_player.play("attack")

	await get_tree().create_timer(1.).timeout

	sprite.visible = false
	attack_finished.emit()
