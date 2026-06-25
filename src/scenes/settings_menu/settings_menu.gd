extends Panel

@onready var fullscreen_cb: CheckButton = $InnerSquare/VContainer/fullscreen_cb
@onready var language: ItemList = $InnerSquare/VContainer/Language
@onready var resolution: OptionButton = $InnerSquare/VContainer/Resolution

const RESOLUTIONS := {
	0: Vector2i(1280, 720),
	1: Vector2i(1600, 900),
	2: Vector2i(1920, 1080),
	3: Vector2i(2560, 1440),
	4: Vector2i(3840, 2160),
}

func _ready() -> void:
	TranslationServer.set_locale("en")

	if (TranslationServer.get_locale() == "pt_BR"):
		language.select(0)
	else:
		language.select(1)

	sync_resolution_button()
	if resolution:
		resolution.disabled = (DisplayServer.window_get_mode()) == DisplayServer.WINDOW_MODE_FULLSCREEN

func _on_fullscreen_cb_toggled(toggled_on: bool) -> void:
	var window_mode: DisplayServer.WindowMode = DisplayServer.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(window_mode)

	if resolution:
		resolution.disabled = toggled_on

func _on_close_btn_pressed() -> void:
	self.visible = false

func _on_visibility_changed() -> void:
	if fullscreen_cb:
		fullscreen_cb.button_pressed = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_item_list_item_selected(index: int) -> void:
	match index:
		0:
			TranslationServer.set_locale("pt_BR")
			Global.dialogue_directory = "res://data/dialogues/dialogues_pt.json"
		1:
			TranslationServer.set_locale("en")
			Global.dialogue_directory = "res://data/dialogues/dialogues_en.json"

func _on_resolution_item_selected(index: int) -> void:
	if RESOLUTIONS.has(index):
		var new_size = RESOLUTIONS[index]

		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_size(new_size)
			center_window(new_size)

func center_window(window_size: Vector2i) -> void:
	var screen_size := DisplayServer.screen_get_size()
	var center_pos := (screen_size / 2) - (window_size / 2)
	DisplayServer.window_set_position(center_pos)

func sync_resolution_button() -> void:
	if resolution:
		var current_size := DisplayServer.window_get_size()

		for key in RESOLUTIONS:
			if RESOLUTIONS[key] == current_size:
				resolution.select(key)
				break

func _on_ac_switch_toggled(toggled_on: bool) -> void:
	SceneManager.set_ac(toggled_on)

func _on_grain_switch_toggled(toggled_on: bool) -> void:
	SceneManager.set_filmgrain(toggled_on)

func _on_vignette_switch_toggled(toggled_on: bool) -> void:
	SceneManager.set_vignette(toggled_on)


func _on_crt_switch_toggled(toggled_on: bool) -> void:
	SceneManager.set_crt(toggled_on)
