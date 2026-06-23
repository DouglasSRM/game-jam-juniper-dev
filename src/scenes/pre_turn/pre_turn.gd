extends Control

@onready var circle: Panel = $Panel/Circle
@onready var bottle: Panel = $Panel/Bottle
@onready var spin_btn: Button = $Panel/Spin
@onready var WeaponSelector: Panel = $Panel/WeaponSelector
@onready var WeaponSprite: Panel = $Panel/WeaponSelector/WeaponSprite
@onready var WeaponName: Panel = $Panel/WeaponSelector/WeaponName

const WEAPONS: Dictionary = {
	1: "Purple",
	2: "Blue",
	3: "Green",
	4: "Orange"
}
var selected_weapon: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spin_bottle() -> void:
	var tween := create_tween()

	var complete_spins := randf_range(3.0, 8.0) * TAU
	var angle := randf_range(0.0, TAU)
	var targe_rotation := bottle.rotation + complete_spins + angle

	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(bottle, "rotation", targe_rotation, 3.0)

	await tween.finished
	var quadrant_result := find_quadrand()

	spin_btn.disabled = false

	selected_weapon = WEAPONS[quadrant_result]
	print(selected_weapon)
	print(quadrant_result)

# TODO: when hits zero, buff the weapn
func find_quadrand() -> int:
	var degrees := rad_to_deg(bottle.rotation)
	var new_degrees := posmod(degrees, 360.0)

	if new_degrees >= 0 and new_degrees < 90: return 1 # Purple: superior direito
	elif new_degrees >= 90 and new_degrees < 180: return 2 # Blue: inferior direito
	elif new_degrees >= 180 and new_degrees < 270: return 3 # Green: inferior esquerdo
	else: return 4 # Orange: superior esquerdo


func _on_spin_pressed() -> void:
	spin_bottle()
