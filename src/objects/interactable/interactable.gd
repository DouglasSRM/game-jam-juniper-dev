class_name Interactable extends Area2D

@export var function_call: String = ""
@onready var key_hint: TextureRect = $KeyHint
var area_active: bool

func _on_ready() -> void:
	area_active = false
	key_hint.visible = false

func _input(event):
	if function_call and area_active and event.is_action_pressed("ui_accept"):
		var scene_root = get_tree().current_scene
		
		if scene_root.has_method(function_call):
			scene_root.call(function_call)

func _on_area_entered(_area: Area2D) -> void:
	if self.visible:
		set_area_active(true)

func _on_area_exited(_area: Area2D) -> void:
	if self.visible:
		set_area_active(false)

func set_area_active(flag: bool) -> void:
	self.area_active = flag
	key_hint.visible = flag
