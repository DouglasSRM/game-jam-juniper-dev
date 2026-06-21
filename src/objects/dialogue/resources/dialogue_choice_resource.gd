class_name DialogueChoice extends DE

@export var speaker_name: String
@export var speaker_img: Texture
@export var speaker_img_HFrames: int = 1
@export var speaker_img_select_frame: int = 0

@export_multiline var text: String

@export var choice_text: Array[String]
@export var choice_function_call: Array[DialogueFunction]
