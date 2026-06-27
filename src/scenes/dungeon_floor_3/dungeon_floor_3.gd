class_name DungeonFloor3 extends BaseScene

var timer_water_animation: float = 0.
@onready var agua_3: TileMapLayer = $TileMaps/Agua3
@onready var agua_2: TileMapLayer = $TileMaps/Agua2
@onready var boss_label: Label = $BossLabel
@onready var parchment: Sprite2D = $Parchment

@onready var interactable: Interactable = $Interactables/Interactable

func _ready() -> void:
	agua_2.visible = false
	agua_3.visible = false
	boss_label.visible = false
	parchment.visible = true

func update_water() -> void:
	if (not agua_2.visible) and (not agua_3.visible):
		agua_2.visible = true
		return

	if agua_2.visible:
		agua_2.visible = false
		agua_3.visible = true
		return

	if agua_3.visible:
		agua_3.visible = false

func _process(delta: float) -> void:
	timer_water_animation += delta

	if timer_water_animation >= 0.5:
		timer_water_animation -= 0.5
		update_water()

func go_to_next_scene() -> void:
	SceneManager.change_scene(self, 'tavern_2')

func show_boss_text() -> void:
	interactable.visible = false
	boss_label.visible = true
	parchment.visible = false
	
	await Utils.sleep(3)
