class_name MainMenu extends Control

@onready var settings_menu: Panel = %settings_menu

@onready var play: Button = %play
@onready var options: Button = %options
@onready var quit: Button = %quit

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var pendulum: AnimatedSprite2D = $background/pendulum
@onready var main_menu: VBoxContainer = $background/main_menu
@onready var art: Sprite2D = $background/art

var acc := 0.6

func _ready() -> void:
	#SceneManager.set_vignette(true)
	#SceneManager.set_ac(true)
	#SceneManager.set_filmgrain(true)
	settings_menu.visible = false
	settings_menu.visibility_changed.connect(Callable(self, "opcoes"))
	main_menu.modulate.a = 0.
	art.modulate.a = 0.

func opcoes():
	quit.disabled = settings_menu.visible

func _on_play_pressed() -> void:
	SceneManager.change_scene(self, "initial_scene")
	audio_stream_player.stop()

func _on_options_pressed() -> void:
	settings_menu.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_creditos_pressed() -> void:
	pass
	#SceneManager.change_scene(self, "creditos/creditos_menu", false, true)

# Final pos (270, 360)
func _on_pendulun_animation_finished() -> void:
	var tween = create_tween()

	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN)

	tween.tween_property(pendulum, "position:x", 360., acc)

	await tween.finished
	show_art()

func show_art() -> void:
	var tween = create_tween()

	tween.tween_property(art, "modulate:a", 1., .5)

	await tween.finished
	show_menu()

func show_menu() -> void:
	var tween = create_tween()

	tween.tween_property(main_menu, "modulate:a", 1., 1.)
