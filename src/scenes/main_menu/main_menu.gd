class_name MainMenu extends Control

const cena_inicial = "initial_scene"

@onready var settings_menu: Panel = %settings_menu

@onready var play: Button = %play
@onready var options: Button = %options
@onready var quit: Button = %quit

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	settings_menu.visible = false
	settings_menu.visibility_changed.connect(Callable(self, "opcoes"))

func opcoes():
	quit.disabled = settings_menu.visible

func _on_play_pressed() -> void:
	SceneManager.change_scene(self, "cutscene")
	audio_stream_player.stop()

func _on_options_pressed() -> void:
	settings_menu.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_creditos_pressed() -> void:
	SceneManager.change_scene(self, "creditos/creditos_menu", false, true)
