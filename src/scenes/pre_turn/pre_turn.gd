extends Control

@onready var circle: TextureRect = $Panel/Circle
@onready var bottle: TextureRect = $Panel/Bottle
@onready var spin_btn: TextureButton = $Panel/Spin
@onready var weapon_selector: TextureRect = $Panel/WeaponSelector
@onready var weapon_sprite: TextureRect = $Panel/WeaponSelector/WeaponSprite
@onready var weapon_name: Label = $Panel/WeaponSelector/WeaponName

const WEAPONS: Dictionary = {
	1: {
		"name": "Kusarigama",
		"icon_path": "res://assets/ui/pre_turn/weapons/kusarigama.png",
		"scene_path": "res://src/objects/weapons/wp_1/weapon_1.tscn",
	},
	2: {
		"name": "Chakram",
		"icon_path": "res://assets/ui/pre_turn/weapons/chakram.png",
		"scene_path": "res://src/objects/weapons/wp_2/weapon_2.tscn",
	},
	3: {
		"name": "Flail",
		"icon_path": "res://assets/ui/pre_turn/weapons/flail.png",
		"scene_path": "res://src/objects/weapons/wp_3/weapon_3.tscn",
	},
	4: {
		"name": "Yoyo",
		"icon_path": "res://assets/ui/pre_turn/weapons/yoyo.png",
		"scene_path": "res://src/objects/weapons/wp_4/weapon_4.tscn",
	},
}

# Old shit - delete later
# 	2: {"name": "Blue", "icon_path": "res://assets/ui/pre_turn/weapon_1.png"},
# 	3: {"name": "Green", "icon_path": "res://assets/ui/pre_turn/weapon_1.png"},
# 	4: {"name": "Orange", "icon_path": "res://assets/ui/pre_turn/weapon_1.png"}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapon_selector.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	pass

func spin_bottle() -> void:
	spin_btn.disabled = true
	weapon_selector.visible = false

	var tween := create_tween()

	var complete_spins := randf_range(3.0, 8.0) * TAU
	var angle := randf_range(0.0, TAU)
	var targe_rotation := bottle.rotation + complete_spins + angle

	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(bottle, "rotation", targe_rotation, 3.0)

	await tween.finished
	var quadrant_result := find_quadrand()
	show_weapon(quadrant_result)
	spin_btn.disabled = false

	print(quadrant_result)

func show_weapon(quadrant: int) -> void:
	var weapon_data = WEAPONS[quadrant]
	weapon_name.text = weapon_data["name"]

	var loaded_texture = load(weapon_data["icon_path"])
	weapon_sprite.texture = loaded_texture

	var weapon_scene = load(weapon_data["scene_path"])
	Global.current_weapon = weapon_scene

	weapon_selector.modulate.a = 0.0
	weapon_selector.scale = Vector2(0.5, 0.5)
	weapon_selector.visible = true

	# Show shit to me
	print("wp_name: ", weapon_name.text)
	print("wp_scene: ", weapon_scene)


	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property(weapon_selector, "modulate:a", 1., .4)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(weapon_selector, "scale", Vector2(1., 1.), .2)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

# TODO: when hits zero, buff the weapn
func find_quadrand() -> int:
	var degrees := rad_to_deg(bottle.rotation)
	var new_degrees := posmod(degrees, 360.0)

	if new_degrees >= 0 and new_degrees < 90: return 1 # Purple: superior direito
	elif new_degrees >= 90 and new_degrees < 180: return 2 # Blue: inferior direito
	elif new_degrees >= 180 and new_degrees < 270: return 3 # Green: inferior esquerdo
	else: return 4 # Orange: superior esquerdo

# On pressed button, spin_bottle

func _on_spin_pressed() -> void:
	spin_bottle()
