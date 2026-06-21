class_name OptionComponent extends Node2D

const option_box_preload = preload("res://src/scenes/base_battle/option_box/option_box.tscn")

@export var activate_instant: bool
@export var only_activate_once: bool
@export var lock_player: bool = false
@export var override_option_position: bool
@export var override_position: Vector2
@export var override_option_size: bool
@export var override_size: Vector2
@export var options: Array[OptionExport]
@export var orientation: OptionBox.OrientationType = OptionBox.OrientationType.HORIZONTAL

var option_top_pos: Vector2 = Vector2(240, 48)
var option_bottom_pos: Vector2 = Vector2(550, 430)

var option_size : Vector2 = Vector2(864, 168)

var player_body_in: bool = false
var has_activated_already: bool = false
var desired_option_pos: Vector2
var desired_option_size: Vector2

var player_node: CharacterBody2D = null

signal option_finished


func _ready():
	if activate_instant:
		activate_option_box.call_deferred()


func activate_option_box() -> void: 
	var new_option_box: OptionBox = option_box_preload.instantiate()
	
	if override_option_position:
		desired_option_pos = override_position
	else:
		desired_option_pos = option_bottom_pos
	
	if override_option_size:
		desired_option_size = override_size
	else:
		desired_option_size = option_size
	
	new_option_box.orientation     = self.orientation
	new_option_box.global_position = self.desired_option_pos
	new_option_box.defined_size    = self.desired_option_size
	new_option_box.option          = self.options
	new_option_box.lock_player     = self.lock_player
	get_parent().add_child(new_option_box)
	new_option_box.option_finished.connect(Callable(self, '_on_option_finished'))
	has_activated_already = true


func set_player_reference():
	for i in get_tree().get_nodes_in_group("player"):
		player_node = i


func _on_option_finished() -> void:
	option_finished.emit()
