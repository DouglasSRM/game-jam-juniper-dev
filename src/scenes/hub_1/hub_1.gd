class_name Hub1 extends BaseScene

func go_to_next_scene() -> void:
	Global.next_battle_scene = 'battle_2'
	SceneManager.change_scene(self, 'pre_turn')
	# SceneManager.change_scene(self, 'battle_2')
