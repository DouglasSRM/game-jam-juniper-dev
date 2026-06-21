class_name DialogueText extends DE

@export var speaker_name: String
@export var speaker_img: Texture
@export var speaker_img_HFrames: int = 1 # Permite selecionar varios frames de animação
@export var speaker_img_rest_frame: int = 0
@export var speaker_img_initial_frame: int = 0
@export_range(1, 30, 1) var speaker_img_step_frame: int = 1 # steps para mudar de frame (caracteres)
@export var font_size: int = 16

@export_multiline var text: String
@export_range(0.1, 30.0, 0.1) var text_speed: float = 10.0

@export var text_sound: AudioStream
@export var text_volume_db: float
@export var text_volume_pitch_min: float = 0.85
@export var text_volume_pitch_max: float = 1.15

#@export var camera_position: Vector2 = Vector2(999.999, 999.999)
#@export_range(0.05, 10.0, 0.05) var camera_transition_time: float = 1.0
