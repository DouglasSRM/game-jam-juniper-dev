class_name Boss3 extends BaseBoss

@onready var attack_boss_3: AttackBoss3 = $Attacks/AttackBoss3

var attacks_array: Array[BaseAttack]

func _ready() -> void:
	super()
	attacks_array.append(attack_boss_3)
