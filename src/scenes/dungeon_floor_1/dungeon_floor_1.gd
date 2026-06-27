class_name DungeonFloor1 extends BaseScene

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
	SceneManager.change_scene(self, 'hub_1')

func _on_trigger_next_scene_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		go_to_next_scene()

func show_boss_text() -> void:
	interactable.visible = false
	boss_label.visible = true
	parchment.visible = false
