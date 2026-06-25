class_name Hub2 extends BaseScene

func go_to_next_scene() -> void:
	Global.next_battle_scene = 'battle_3'
	SceneManager.change_scene(self, 'pre_turn')
	# SceneManager.change_scene(self, 'battle_3')
