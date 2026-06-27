class_name Tavern extends BaseScene

@onready var tio: Tio = $Tio
@onready var doctor: Sprite2D = $Doctor
@onready var georgie: Sprite2D = $GeorgieOldMan
@onready var erie: Sprite2D = $Erie
@onready var lenora: BaseCharacter = $Lenora
@onready var black: ColorRect = $Black
@onready var bully: Sprite2D = $Bully
@onready var random_1: Sprite2D = $Random1
@onready var random_2: Sprite2D = $Random2


@onready var dialogue_area_uncle: DialogArea = $Dialogues/DialogueAreaUncle
@onready var dialogue_area_doctor: DialogArea = $Dialogues/DialogueAreaDoctor
@onready var dialogue_area_old_georgie: DialogArea = $Dialogues/DialogueAreaOldGeorgie
@onready var dialogue_area_erie: DialogArea = $Dialogues/DialogueAreaErie
@onready var dialogue_area_lenora: DialogArea = $Dialogues/DialogueAreaLenora

@onready var portinhola_aberta: TileMapLayer = $TileMaps/PortinholaAberta
@onready var portinhola_fechada: TileMapLayer = $TileMaps/PortinholaFechada

@onready var door: TileMapLayer = $TileMaps/Door

signal plimbous

func _ready() -> void:
	switch_portinhola(false)
	door.visible = false
	black.visible = false
	black.modulate.a = 0.
	dialogue_area_uncle.visible = false

func go_to_next_scene() -> void:
	SceneManager.change_scene(self, 'dungeon_entrance')

func tio_vai_embora() -> void:
	switch_portinhola(true)
	await tio.walk("up", 250, 1.5)
	tio.stop_walking(0)
	tio.animation_player.play("local/down")
	plimbous.emit()

func porta_abre() -> void:
	door.visible = true
	#await tio.walk("up", 250, 0.2)
	tio.position = Vector2(2000, 2000)

func switch_portinhola(open: bool) -> void:
	portinhola_aberta.visible = open
	portinhola_fechada.visible = not open
	portinhola_fechada.enabled = not open

func play_bubble_sound() -> void:
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	var bubble_sound = load("res://assets/sfx/bubble_explode.ogg")
	audio_player.volume_db += 20
	audio_player.stream = bubble_sound
	audio_player.play()
	audio_player.finished.connect(audio_player.queue_free)

func accept_quest() -> void:
	black.visible = true

	var tween_black = create_tween()
	tween_black.tween_property(black, "modulate:a", 1., .5)
	await tween_black.finished

	# sprites
	doctor.visible = false
	georgie.visible = false
	erie.visible = false
	lenora.visible = false
	bully.visible = false
	random_1.visible = false
	random_2.visible = false


	# collisions
	# doctor.collision_shape.disabled = true
	# georgie.collision_shape.disabled = true
	# erie.collision_shape.disabled = true
	lenora.collision_shape.disabled = true
	
	# dialogues
	dialogue_area_doctor.visible = false
	dialogue_area_old_georgie.visible = false
	dialogue_area_erie.visible = false
	dialogue_area_lenora.visible = false
	
	dialogue_area_uncle.visible = true

	# New uncle pos: 270.0, 667.0
	tio.position = Vector2(250., 667.)

	await Utils.sleep(1)
	
	var tween_alpha = create_tween()
	tween_alpha.tween_property(black, "modulate:a", 0., .5)
	await tween_alpha.finished
	black.visible = false
