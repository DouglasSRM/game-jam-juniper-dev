class_name BaseCharacter extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var autoplay: String = ""

var estatico: bool = true

func _process(_delta: float) -> void:
	if autoplay and !animation_player.is_playing():
		animation_player.play(autoplay)

func _physics_process(_delta: float) -> void:
	if !estatico:
		move_and_slide()

func stop_walking(timer: float):
	self.velocity = Vector2(0,0)
	self.animation_player.stop()
	if timer:
		await Utils.sleep(timer)

func walk(direction: String, speed, duration: float):
	var old_estatico = self.estatico
	self.estatico = false
	if (direction == "right"):
		self.animation_player.play("walk_right")
		self.velocity = Vector2(speed,0)
		await Utils.sleep(duration)
	elif (direction == "left"):
		self.animation_player.play("walk_left")
		self.velocity = Vector2(-speed,0)
		await Utils.sleep(duration)
	elif (direction == "up"):
		self.animation_player.play("walk_up")
		self.velocity = Vector2(0,-speed)
		await Utils.sleep(duration)
	elif (direction == "down"):
		self.animation_player.play("walk_down")
		self.velocity = Vector2(0,speed)
		await Utils.sleep(duration)
	else:
		print("direção nao encontrada")
	self.estatico = old_estatico
