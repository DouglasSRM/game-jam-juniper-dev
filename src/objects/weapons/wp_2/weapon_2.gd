class_name WeaponTwo extends BaseWeapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	damage = 1
	stamina_cost = 3
	wp_name = "Magic YOYO"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
