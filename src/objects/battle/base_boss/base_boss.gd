class_name BaseBoss extends Entity

#@onready var sprite_attack: Sprite2D = $SpriteAttack
@onready var attacks: Node2D = $Attacks
signal damaged
var can_change_animation: bool = true

func attack() -> void:
	pass

func take_damage(value: float) -> void:
	super(value)
	damaged.emit()
	_apply_damage_animation()
	
func _ready() -> void:
	super()
	#attacks.visible = false

func set_health(value: float) -> void:
	super(value)
	
# Precisa criar um animatedSprite2D no Boss_number
# para poder usar a funcao
func _apply_damage_animation() -> void:
	pass
