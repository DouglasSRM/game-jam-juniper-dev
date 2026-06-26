class_name Tavern extends BaseScene

@onready var tio: Tio = $Tio

@onready var portinhola_aberta: TileMapLayer = $TileMaps/PortinholaAberta
@onready var portinhola_fechada: TileMapLayer = $TileMaps/PortinholaFechada

@onready var door: TileMapLayer = $TileMaps/Door

signal plimbous

func _ready() -> void:
	switch_portinhola(false)
	door.visible = false

func go_to_next_scene() -> void:
	SceneManager.change_scene(self, 'dungeon_entrance')

func tio_vai_embora() -> void:
	switch_portinhola(true)
	await tio.walk("up", 250, 1.5)
	tio.stop_walking(0)
	plimbous.emit()

func porta_abre() -> void:
	door.visible = true
	#await tio.walk("up", 250, 0.2)
	tio.position = Vector2(2000, 2000)

func switch_portinhola(open: bool) -> void:
	portinhola_aberta.visible = open
	portinhola_fechada.visible = not open
