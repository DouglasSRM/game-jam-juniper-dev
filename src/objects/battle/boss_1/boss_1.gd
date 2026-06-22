class_name Boss1 extends BaseBoss

@onready var attack_boss_1: AttackBoss1 = $Attacks/AttackBoss1

var attacks_array: Array[BaseAttack]

func _ready() -> void:
	super()
	attacks_array.append(attack_boss_1)
