class_name DungeonEntrance extends BaseScene

func go_to_next_scene() -> void:
	Global.next_battle_scene = 'battle_1'
	SceneManager.change_scene(self, 'pre_turn')
	# SceneManager.change_scene(self, 'battle_1')
