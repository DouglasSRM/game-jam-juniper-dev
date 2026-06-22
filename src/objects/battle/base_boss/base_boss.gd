class_name BaseBoss extends Entity

#@onready var sprite_attack: Sprite2D = $SpriteAttack
@onready var attacks: Node2D = $Attacks

func attack() -> void:
	pass

func take_damage(value: int) -> void:
	super(value)
	
func _ready() -> void:
	super()
	#attacks.visible = false

func set_health(value: int) -> void:
	super(value)
