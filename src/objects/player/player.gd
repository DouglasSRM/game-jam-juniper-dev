class_name Player extends BaseCharacter

var speed: int = 300
@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

const SECONDS_FOR_IDLE_ANIMATION = 4

var uniforme: bool = false
var walking: bool = false
var can_move: bool = true
var force_walk: bool = false

var is_yoyo: bool = false

var timer: float = 0

func start_yoyo_animation() -> void:
	animations.play("start_yoyo")
	await animations.animation_finished
	if is_yoyo:
		animations.play("yoyo")

func _process(delta: float) -> void:
	if not is_yoyo and not animations.is_playing() and can_move:
		timer += delta
	
	if timer >= SECONDS_FOR_IDLE_ANIMATION:
		is_yoyo = true
		timer = 0
		start_yoyo_animation()

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
		is_yoyo = false
		animations.play("walk_"+direction)
	elif not is_yoyo and animations.is_playing():
		timer = 0
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
