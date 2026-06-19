extends Panel

@onready var fullscreen_cb: CheckButton = $settings_menu/fullscreen_cb
@onready var language: ItemList = $settings_menu/Language

func _ready() -> void:
	if (TranslationServer.get_locale() == "pt_BR"):
		language.select(0)
	else:
		language.select(1)

func _on_fullscreen_cb_toggled(toggled_on: bool) -> void:
	var window_mode: DisplayServer.WindowMode = DisplayServer.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WINDOW_MODE_WINDOWED  
	DisplayServer.window_set_mode(window_mode)


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
