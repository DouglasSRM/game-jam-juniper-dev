class_name DialogArea extends Area2D

const dialogue_system_preload = preload("res://src/objects/dialogue/dialogue_system.tscn")

@export var activate_instant: bool
@export var only_activate_once: bool
@export var lock_player: bool = false
@export var override_dialogue_position: bool
@export var override_position: Vector2
@export var dialogue: Array[DE]
@export var show_key_hint: bool = true

@onready var key_hint: TextureRect = $KeyHint

var dialogue_top_pos: Vector2 = Vector2(240, 48)
var dialogue_bottom_pos: Vector2 = Vector2(960, 800)

var player_body_in: bool = false
var has_activated_already: bool = false
var desired_dialogue_pos: Vector2

var player_node: CharacterBody2D = null

signal dialogue_finished

func _ready():
	key_hint.visible = false
	set_player_reference()

func _process(_delta: float) -> void:
	if !player_node:
		set_player_reference()
		return
	
	if !activate_instant and player_body_in:
		if only_activate_once and has_activated_already:
			set_process(false)
			return
		
		if Input.is_action_just_pressed("ui_accept"):
			_activate_dialogue()
			player_body_in = false

func set_player_reference():
	for i in get_tree().get_nodes_in_group("player"):
		player_node = i

func _activate_dialogue() -> void:
	set_key_hint(false)
	 
	if player_node and lock_player:
		player_node.can_move = false
	
	var new_dialogue: DialogueSystem = dialogue_system_preload.instantiate()
	if override_dialogue_position:
		desired_dialogue_pos = override_position
	else:
		desired_dialogue_pos = dialogue_bottom_pos
	
	new_dialogue.global_position = self.desired_dialogue_pos
	new_dialogue.dialogue        = self.dialogue
	new_dialogue.lock_player     = self.lock_player
	get_parent().add_child(new_dialogue)
	#push_font_size(10) #.get_font_list)
	new_dialogue.dialogue_finished.connect(Callable(self, '_on_dialogue_finished'))
	has_activated_already = true

func _on_dialogue_finished() -> void:
	dialogue_finished.emit()

func _on_body_entered(body: Node2D) -> void:
	set_key_hint(false)
	if !self.visible:
		return
	if only_activate_once and has_activated_already:
		return
	if body.is_in_group("player"):
		player_body_in = true
		if activate_instant:
			_activate_dialogue()
		else:
			set_key_hint(true)

func _on_body_exited(body: Node2D) -> void:
	set_key_hint(false)
	if !self.visible:
		return
	
	if body.is_in_group("player"):
		player_body_in = false

func set_key_hint(flag: bool) -> void:
	if show_key_hint:
		key_hint.visible = flag
