class_name DungeonFloor2 extends BaseScene

func go_to_next_scene() -> void:
	SceneManager.change_scene(self, 'hub_2')
