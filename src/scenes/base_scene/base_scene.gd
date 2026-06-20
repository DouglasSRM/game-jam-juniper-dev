class_name BaseScene extends Node2D

@onready var player: Player = $Player
@onready var entrance_markers: Node2D = $EntranceMarkers

var can_enter_transition: bool = false

func _ready() -> void:
	if SceneManager.player:
		can_enter_transition = false
		if player:
			player.queue_free()
		
		player = SceneManager.player
		add_child(player)
		position_player()
	player.animations.play("walk_down")
	await get_tree().create_timer(0.5).timeout
	can_enter_transition = true

func position_player() -> void:
	if SceneManager.trigger_name:
		for entrance in entrance_markers.get_children():
			if entrance is Marker2D and entrance.name == SceneManager.trigger_name:
				player.global_position = entrance.global_position
				SceneManager.trigger_name = ""
				return
	
	for entrance in entrance_markers.get_children():
		if entrance is Marker2D and entrance.name == "Any":
			player.global_position = entrance.global_position
