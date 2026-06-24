class_name AttackBoss2 extends BaseAttack

func _ready() -> void:
	super()
	damage = 3.3
	step = 4
	pre_step_duration = 0
	step_duration = 1

func run_animation() -> void:
	sprite.visible = true
	animation_player.play("attack")
	await animation_player.animation_finished
	
	attack_finished.emit()
	sprite.visible = false
