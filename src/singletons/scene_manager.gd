extends CanvasLayer

var scene_stack: Array[Node] = []

var player: Player
var trigger_name: String

var scene_dir_path = "res://src/scenes/"

@onready var pause_menu = preload("res://src/scenes/pause_menu/pause_menu.tscn").instantiate()

@onready var transition_effect: ColorRect = $transition_effect
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dark_effect: ColorRect = $dark_effect
@onready var circle: ColorRect = $circle

var dark_effect_value: float = 1.2

func push_scene(scene: String):
	var full_path = scene_dir_path + scene +".tscn"
	var current = get_tree().current_scene
	if current:
		scene_stack.push_back(current)
		get_tree().root.remove_child(current)
	
	var new_scene = load(full_path).instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene

func pop_scene():
	if scene_stack.size() == 0:
		return
	
	var current = get_tree().current_scene
	if current:
		current.queue_free()
	
	var last = scene_stack.pop_back()
	get_tree().root.add_child(last)
	get_tree().current_scene = last

func _ready():
	add_child(pause_menu)
	pause_menu.visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		var origem: String = get_tree().current_scene.scene_file_path.get_file().get_basename()
		if origem != "main_menu" and origem != "creditos" and origem != "creditos_menu":
			toggle_pause()

func toggle_pause():
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused

func change_scene(from, to_scene_name: String, transicao: bool = true, detailed: bool = false) -> void:
	var full_path: String
	if detailed:
		full_path = scene_dir_path + to_scene_name +".tscn"
	else:
		full_path = scene_dir_path + to_scene_name +"/"+to_scene_name+".tscn"
	
	if from is BaseScene:
		player = from.player
		player.get_parent().remove_child(player)
	
	if transicao:
		animation_player.play("carimbo_in")
		await animation_player.animation_finished
	
	from.get_tree().call_deferred("change_scene_to_file", full_path)
	if transicao:
		animation_player.play("carimbo_out")

func change_scene_circle(from, to_scene_name: String):
	circle.visible = true
	(circle.material as ShaderMaterial).set_shader_parameter("pos", Vector2(0.12, 0.4))
	animation_player.play("circle_trans_in")
	await SceneManager.animation_player.animation_finished
	change_scene(from, to_scene_name, false, true)
	(circle.material as ShaderMaterial).set_shader_parameter("pos", Vector2(0.5, 0.5))
	animation_player.play("circle_trans_out_2")
	await SceneManager.animation_player.animation_finished
	circle.visible = false

func change_scene_weep(from, to_scene_name: String):
	transition_effect.visible = true
	animation_player.play("transition_out")
	await SceneManager.animation_player.animation_finished
	change_scene(from, to_scene_name, false, true)
	animation_player.play("transition_in")
	await SceneManager.animation_player.animation_finished
	transition_effect.visible = false

func fade_in():
	animation_player.play("transition_out")
	await animation_player.animation_finished

func fade_out():
	animation_player.play("transition_in")
	await animation_player.animation_finished

func set_dark_effect():
	dark_effect.visible = true
	(dark_effect.material as ShaderMaterial).set_shader_parameter("radius", dark_effect_value)
	dark_effect_value -= 0.1
