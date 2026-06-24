class_name BaseWeapon extends Node2D

@onready var wp_sprite: Sprite2D = $wp_sprite

var damage: int = 0
var stamina_cost: int = 0
var wp_name: String = ""


func set_sprite(sprite_path: String) -> void:
	var load_texture := load(sprite_path)
	wp_sprite.texture = load_texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
