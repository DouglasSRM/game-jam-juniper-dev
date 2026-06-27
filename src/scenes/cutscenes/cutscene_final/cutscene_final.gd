extends Node2D

func _ready() -> void:
	run_cutscene.call_deferred()

func run_cutscene() -> void:
	await Utils.sleep(5)
	SceneManager.change_scene(self, 'credits')
