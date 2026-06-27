class_name Boss2 extends BaseBoss

@onready var attack_boss_2: AttackBoss2 = $Attacks/AttackBoss2
@onready var boss_enemy_sprite: AnimatedSprite2D = $BossEnemy

var attacks_array: Array[BaseAttack]

func _ready() -> void:
	super()
	attacks_array.append(attack_boss_2)
	
func _apply_damage_animation() -> void:
	if can_change_animation:
		boss_enemy_sprite.play("taking_damage")
		
		await boss_enemy_sprite.animation_finished
		boss_enemy_sprite.play("idle")
