class_name PlayerBattle extends Entity

@onready var attack_yoyo: AttackYoyo = $Attacks/AttackYoyo
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var attacks: Array[BaseAttack]


func _ready() -> void:
	super()
	attacks.append(attack_yoyo)
	resume_animation()

func pause_animation() -> void:
	animation_player.stop()

func resume_animation() -> void:
	animation_player.play("idle")

func set_health(value: int) -> void:
	super(value)
