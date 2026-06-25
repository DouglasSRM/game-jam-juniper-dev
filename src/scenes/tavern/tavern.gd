class_name Tavern extends BaseScene

@onready var tio: Tio = $Tio

signal plimbous

func go_to_next_scene() -> void:
	SceneManager.change_scene(self, 'dungeon_entrance')

func tio_vai_embora() -> void:
	await tio.walk("up", 250, 1.7)
	plimbous.emit()

func porta_abre() -> void:
	await tio.walk("up", 250, 1.7)
