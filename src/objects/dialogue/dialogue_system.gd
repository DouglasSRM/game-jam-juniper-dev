class_name DialogueSystem extends Node2D

const dialogue_button_preload = preload("res://src/objects/dialogue/dialogue_button.tscn")

@onready var speaker_parent: Control = $HBoxContainer/SpeakerParent
@onready var dialogue_label: RichTextLabel = $HBoxContainer/VBoxContainer/DialogueLabel
@onready var speaker_sprite: Sprite2D = $HBoxContainer/SpeakerParent/SpeakerSprite
@onready var button_container: HBoxContainer = $HBoxContainer/VBoxContainer/ButtonContainer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var speaker_name_label: Label = $SpeakerNameLabel

var dialogue: Array[DE]
var current_dialogue_item: int = 0
var next_item: bool = true
var lock_player: bool = false

var player_node: Player

signal dialogue_finished

var speaker_label_left_positon := Vector2(-400., -250.)
var speaker_label_right_positon := Vector2(-715., -250.)

func _ready() -> void:
	visible = false
	button_container.visible = false
	if lock_player:
		set_player_reference()

func set_player_reference():
	for i in get_tree().get_nodes_in_group("player"):
		player_node = i

func _process(_delta: float) -> void:
	if current_dialogue_item == dialogue.size(): # Checa se é o ultimo item do array
		if !player_node and lock_player:
			set_player_reference()
			return
		
		dialogue_finished.emit()
		if player_node and lock_player:
			player_node.can_move = true
		queue_free()
		return
	
	if next_item:
		next_item = false
		var i = dialogue[current_dialogue_item]
		
		if i.speaker_on_right:
			set_speaker_right()
		else:
			set_speaker_left()
		
		if i is DialogueFunction:
			self.visible = !i.hide_dialogue_box
			_function_resource(i)
		elif i is DialogueChoice:
			self.visible = true
			_choice_resource(i)
		elif i is DialogueText:
			self.visible = true
			_text_resource(i)
		else:
			printerr("Resource do tipo DE adicionado acidentalmente!")
			current_dialogue_item += 1
			next_item = true

func set_speaker_right() -> void:
	speaker_parent.get_parent().move_child(speaker_parent, 1)
	speaker_name_label.position = speaker_label_right_positon

func set_speaker_left() -> void:
	speaker_parent.get_parent().move_child(speaker_parent, 0)
	speaker_name_label.position = speaker_label_left_positon

func _function_resource(i: DialogueFunction) -> void:
	var target_node: Node = get_node(i.target_path)
	if target_node.has_method(i.function_name):
		if i.function_arguments.size() == 0:
			target_node.call(i.function_name)
		else:
			target_node.callv(i.function_name, i.function_arguments)
	
	if i.wait_for_signal_to_continue:
		await signal_to_continue(target_node, i.wait_for_signal_to_continue)
	
	current_dialogue_item += 1
	next_item = true

func signal_to_continue(target_node: Node, signal_name: String) -> void:
	if target_node.has_signal(signal_name):
		#var signal_state: Dictionary = { "done": false }
		## usa um dicionario para a flag pois lambda functions não podem editar valores de fora,
		## como o dicionário é um objeto por referência, o conteúdo pode ser modificado dentro da lambda
		#var callable: Callable = func(_args): signal_state.done = true
		#target_node.connect(signal_name, callable, CONNECT_ONE_SHOT)
		await Signal(target_node, signal_name)
		#while not signal_state.done:
		#	await get_tree().process_frame

func _choice_resource(i: DialogueChoice) -> void:
	if i.speaker_name == "protagonista":
		speaker_name_label.text = Global.nome_protagonista
	else:
		speaker_name_label.text = i.speaker_name
	
	dialogue_label.text = i.text
	dialogue_label.visible_characters = -1
	if i.speaker_img:
		speaker_parent.visible = true
		speaker_sprite.texture = i.speaker_img
		speaker_sprite.hframes = i.speaker_img_HFrames
		speaker_sprite.frame = min(i.speaker_img_select_frame, i.speaker_img_HFrames-1)
	else:
		speaker_parent.visible = false
	button_container.visible = true
	
	for item in i.choice_text.size():
		var dialogue_button_var = dialogue_button_preload.instantiate()
		dialogue_button_var.text = i.choice_text[item]
		
		var function_resource: DialogueFunction = i.choice_function_call[item]
		if function_resource:
			dialogue_button_var.connect("pressed",
										Callable(get_node(function_resource.target_path), function_resource.function_name).bindv(function_resource.function_arguments),
										CONNECT_ONE_SHOT)
			
			if function_resource.hide_dialogue_box:
				dialogue_button_var.connect("pressed",
											hide,
											CONNECT_ONE_SHOT)
			
			dialogue_button_var.connect("pressed",
										_choice_button_pressed.bind(get_node(function_resource.target_path), function_resource.wait_for_signal_to_continue),
										CONNECT_ONE_SHOT)
		else:
			dialogue_button_var.connect("pressed",
										_choice_button_pressed.bind(null, ""),
										CONNECT_ONE_SHOT)
		
		button_container.add_child(dialogue_button_var)
	button_container.get_child(0).grab_focus()

func _choice_button_pressed(target_node: Node, wait_for_signal_to_continue: String) -> void:
	button_container.visible = false
	for i in button_container.get_children():
		i.queue_free()
	
	# caso for adicionar um som ao clicar no botão, adicionar aqui
	
	if wait_for_signal_to_continue:
		await signal_to_continue(target_node, wait_for_signal_to_continue)
	
	current_dialogue_item += 1
	next_item = true

func get_dialogue_text(p_text) -> String:
	
	if FileAccess.file_exists(Global.dialogue_directory):
		FileAccess.open(Global.dialogue_directory, FileAccess.READ)
		var json: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(Global.dialogue_directory))
		if json.has(p_text):
			return json[p_text]
		else:
			return p_text
	return p_text

func _text_resource(i: DialogueText) -> void:
	if i.speaker_name == "protagonista":
		speaker_name_label.text = Global.nome_protagonista
	else:
		speaker_name_label.text = i.speaker_name
	
	audio_stream_player.stream = i.text_sound
	audio_stream_player.volume_db = i.text_volume_db
	
	# desabilitada a função de mover a camera
	#var camera: Camera2D = get_viewport().get_camera_2d()
	#if camera and i.camera_position != Vector2(999.999, 999.999):
		#var camera_tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
		#camera_tween.tween_property(camera, "global_position", i.camera_position, i.camera_transition_time)
	
	if i.speaker_img:
		speaker_parent.visible = true
		speaker_sprite.texture = i.speaker_img
		speaker_sprite.hframes = i.speaker_img_HFrames
		speaker_sprite.frame = 0
	else:
		speaker_parent.visible = false
	
	var text = get_dialogue_text(i.text)
	
	dialogue_label.add_theme_font_size_override("normal_font_size", i.font_size)
	dialogue_label.visible_characters = 0
	dialogue_label.text = text
	var text_without_square_brackets: String = _text_without_square_brackets(text)
	var total_characters: int = text_without_square_brackets.length()
	var character_timer: float = 0.0
	
	var count: int = 0
	
	while (dialogue_label.visible_characters < total_characters):
		if Input.is_action_just_pressed("ui_accept") and (dialogue_label.visible_characters > 0):
			dialogue_label.visible_characters = total_characters
			break
		character_timer += get_process_delta_time()
		if (character_timer >= 1.0 / i.text_speed) or (text_without_square_brackets[dialogue_label.visible_characters] == " "):
			var character: String = text_without_square_brackets[dialogue_label.visible_characters]
			dialogue_label.visible_characters += 1
			if character != " ":
				audio_stream_player.pitch_scale = randf_range(i.text_volume_pitch_min, i.text_volume_pitch_max)
				audio_stream_player.play()
				if (speaker_parent.visible) and (i.speaker_img_HFrames > 1):
					if count == 0:
						speaker_sprite.frame = i.speaker_img_initial_frame
					count += 1
					if count % i.speaker_img_step_frame == 0:
						if speaker_sprite.frame < i.speaker_img_HFrames - 1:
							speaker_sprite.frame += 1
						else:
							speaker_sprite.frame = 0
			character_timer = 0.0
		await get_tree().process_frame
	
	if (speaker_parent.visible):
		speaker_sprite.frame = min(i.speaker_img_rest_frame, i.speaker_img_HFrames-1)
	
	while true:
		await get_tree().process_frame
		if (dialogue_label.visible_characters == total_characters):
			if Input.is_action_just_pressed("ui_accept"):
				current_dialogue_item += 1
				next_item = true
				break

func _text_without_square_brackets(text: String) -> String:
	var result: String = ""
	var inside_bracket: bool = false
	
	for i in text:
		if i == "[":
			inside_bracket = true
			continue
		if i == "]":
			inside_bracket = false
			continue
		if !inside_bracket:
			result += i
	
	return result
