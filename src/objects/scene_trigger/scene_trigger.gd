class_name SceneTrigger extends Area2D

@export var connected_scene: String
@export var trigger_name: String
@export var enabled: bool = true
var scene_folder = "res://src/scenes/"

func _on_body_entered(_body: Node2D) -> void:
	if !self.visible:
		return
	
	var cena_pai: BaseScene = self.owner
	if enabled and cena_pai.can_enter_transition:
		SceneManager.trigger_name = self.trigger_name
		SceneManager.change_scene(cena_pai, connected_scene)
