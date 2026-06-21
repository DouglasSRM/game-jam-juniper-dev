class_name OptionBox extends Node2D

const option_button_preload = preload("res://src/scenes/base_battle/option_box/option_button.tscn")

enum OrientationType {
	HORIZONTAL,
	VERTICAL
}

@onready var h_button_container: HBoxContainer = $HBoxContainer/VBoxContainer/HButtonContainer
@onready var v_button_container: VBoxContainer = $HBoxContainer/VBoxContainer/VButtonContainer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var speaker_name_label: Label = $SpeakerNameLabel

@onready var panel: Panel = $Panel
@onready var h_box_container: HBoxContainer = $HBoxContainer

var orientation: OrientationType
var option: Array[OptionExport]
var current_option_item: int = 0
var next_item: bool = true
var lock_player: bool = false
var button_container: BoxContainer

var defined_size: Vector2

var player_node: Player

signal option_finished

func _ready() -> void:
	visible = false
	h_button_container.visible = false
	v_button_container.visible = false
	
	panel.size = defined_size
	h_box_container.size = defined_size

func _process(_delta: float) -> void:
	if current_option_item == option.size(): # Checa se é o ultimo item do array
		option_finished.emit()
		queue_free()
		return
	
	if next_item:
		next_item = false
		var i = option[current_option_item]
		
		if i is OptionFunction:
			self.visible = !i.hide_option_box
			_function_resource(i)
		elif i is OptionChoice:
			self.visible = true
			_choice_resource(i)
		else:
			printerr("Resource do tipo OptionExport adicionado acidentalmente!")
			current_option_item += 1
			next_item = true


func _function_resource(i: OptionFunction) -> void:
	var target_node: Node = get_node(i.target_path)
	if target_node.has_method(i.function_name):
		if i.function_arguments.size() == 0:
			target_node.call(i.function_name)
		else:
			target_node.callv(i.function_name, i.function_arguments)
	
	if i.wait_for_signal_to_continue:
		await signal_to_continue(target_node, i.wait_for_signal_to_continue)
	
	current_option_item += 1
	next_item = true


func signal_to_continue(target_node: Node, signal_name: String) -> void:
	if target_node.has_signal(signal_name):
		await Signal(target_node, signal_name)


func _choice_resource(i: OptionChoice) -> void:
	if orientation == HORIZONTAL:
		button_container = h_button_container
	else:
		button_container = v_button_container
	
	button_container.visible = true
	
	for item in i.choice_text.size():
		var option_button_var = option_button_preload.instantiate()
		option_button_var.text = i.choice_text[item]
		option_button_var.add_theme_font_size_override("font_size", i.font_size)
		
		var function_resource: OptionFunction = i.choice_function_call[item]
		if function_resource:
			option_button_var.connect("pressed",
										Callable(get_node(function_resource.target_path), function_resource.function_name).bindv(function_resource.function_arguments),
										CONNECT_ONE_SHOT)
			
			if function_resource.hide_option_box:
				option_button_var.connect("pressed",
											hide,
											CONNECT_ONE_SHOT)
			
			option_button_var.connect("pressed",
										_choice_button_pressed.bind(get_node(function_resource.target_path), function_resource.wait_for_signal_to_continue),
										CONNECT_ONE_SHOT)
		else:
			option_button_var.connect("pressed",
										_choice_button_pressed.bind(null, ""),
										CONNECT_ONE_SHOT)
		
		button_container.add_child(option_button_var)
	button_container.get_child(0).grab_focus()


func _choice_button_pressed(target_node: Node, wait_for_signal_to_continue: String) -> void:
	button_container.visible = false
	for i in button_container.get_children():
		i.queue_free()
	
	# caso for adicionar um som ao clicar no botão, adicionar aqui
	
	if wait_for_signal_to_continue:
		await signal_to_continue(target_node, wait_for_signal_to_continue)
	
	current_option_item += 1
	next_item = true


func get_battle_text(p_text) -> String:
	if FileAccess.file_exists(Global.option_directory):
		FileAccess.open(Global.option_directory, FileAccess.READ)
		var json: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(Global.option_directory))
		if json.has(p_text):
			return json[p_text]
		else:
			return p_text
	return p_text


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
