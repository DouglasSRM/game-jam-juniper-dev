class_name Player extends BaseCharacter

@export var speed: int = 150
@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

var uniforme: bool = false
var walking: bool = false
var can_move: bool = true
var force_walk: bool = false

func _on_ready() -> void:
	animation_player = animations
	add_to_group("player")
	
	for i in get_children():
		if i is Camera2D:
			i.offset.x = self.position.x
			i.offset.y = self.position.y

func handle_input():
	var moveDirection: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	walking = (moveDirection == Vector2(0,0))
	velocity = moveDirection*speed

func walk(direction: String, spd, duration: float):
	force_walk = true
	await super(direction, spd, duration)
	force_walk = false

func update_animations():
	var direction = ""
	
	if Input.is_action_pressed("ui_left"):
		direction = "left"
	elif Input.is_action_pressed("ui_right"):
		direction = "right"
	elif Input.is_action_pressed("ui_up"):
		direction = "up"
	elif Input.is_action_pressed("ui_down"):
		direction = "down"
	
	if direction != "":
		animations.play("walk_"+direction)
	else:
		animations.stop()

func _physics_process(_delta: float) -> void:
	if force_walk:
		super(_delta)
		return
	
	if !can_move:
		if animations.current_animation.contains("walk"):
			animations.stop()
		return
	
	handle_input()
	move_and_slide()
	update_animations()

func trocar_uniforme():
	if !uniforme:
		sprite_2d.texture = load("res://assets/characters/protagonista/julia-uniforme-Sheet.png")
		sprite_2d.vframes = 4
		uniforme = true
	else:
		sprite_2d.texture = load("res://assets/characters/protagonista/player_spritesheet.png")
		sprite_2d.vframes = 7
		uniforme = false
