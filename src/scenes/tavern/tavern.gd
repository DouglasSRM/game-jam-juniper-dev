class_name Tavern extends BaseScene

func go_to_next_scene() -> void:
	SceneManager.change_scene(self, 'dungeon_entrance')
