class_name Boss2 extends BaseBoss

@onready var attack_boss_2: AttackBoss2 = $Attacks/AttackBoss2

var attacks_array: Array[BaseAttack]

func _ready() -> void:
	super()
	attacks_array.append(attack_boss_2)
