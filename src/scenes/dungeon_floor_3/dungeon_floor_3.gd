class_name DungeonFloor3 extends BaseScene

func go_to_next_scene() -> void:
	SceneManager.change_scene(self, 'tavern_2')
