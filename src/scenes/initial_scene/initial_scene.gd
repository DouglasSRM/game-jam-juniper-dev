class_name InitialScene extends BaseScene

func go_to_next_scene() -> void:
	SceneManager.change_scene(self, 'tavern')
