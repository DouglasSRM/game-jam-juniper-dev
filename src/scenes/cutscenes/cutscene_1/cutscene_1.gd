class_name Cutscene1 extends Node2D

@onready var animated_sprite: Sprite2D = $Sprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var dialogue_area: DialogArea = $DialogueArea

signal next

func _ready() -> void:
	#audio_stream_player.play()
	
	await Utils.sleep(2)
	
	dialogue_area._activate_dialogue()

func next_frame() -> void:
	if animated_sprite.frame >= 3:
		SceneManager.change_scene(self, 'tavern')
		return

	await Utils.sleep(1)
	
	animated_sprite.frame += 1
	await Utils.sleep(2)
	
	next.emit()
	
