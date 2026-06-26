class_name Cutscene1 extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	run_cutscene.call_deferred()
	audio_stream_player.play()

func run_cutscene() -> void:
	animated_sprite.play()
	await animated_sprite.animation_finished
	SceneManager.change_scene(self, 'tavern')
