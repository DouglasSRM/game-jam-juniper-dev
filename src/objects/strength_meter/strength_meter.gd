class_name StrengthMeter extends Node2D

enum HitType {
	MISS,
	HIT,
	CRIT
}

@onready var sprite_multiplicator: Sprite2D = $SpriteMultiplicator
@onready var sprite_result: Sprite2D = $SpriteResult

var radius: float = 150.

const BASE_DIR := Vector2.UP

var rotation_speeds: Array[float] = [180., 210., 250., 280., 360.] # graus por segundo
var green_sizes: Array[float] = [50.0, 40.0, 30.0, 20.0, 10.0]
var yellow_sizes: Array[float] = [25.0, 20.0, 15.0, 12.5, 10.0]

var multipliers: Array[float] = [1.0, 1.2, 1.5, 1.8, 2.0]

var rotation_speed: float = rotation_speeds[0]
var green_size_deg: float = green_sizes[0]
var yellow_size_deg: float = yellow_sizes[0]

var current_level: int = 0

var hit_count : int = 0
var crit_count: int = 0

var angle: float = 0.
var rotating: bool = false

var sector_start_angle: float

var is_active: bool = false

signal return_multiplier(value: float)

func next_round() -> void:
	if current_level == 4:
		end_run()
		return
	
	current_level += 1
	angle = 0
	sprite_result.visible = false
	sprite_multiplicator.visible = true
	set_circle()
	is_active = true
	rotating = true

func set_attack_2() -> void:
	rotation_speeds = [250., 275., 290., 320., 400.] # graus por segundo

func activate(index: int) -> void:
	if index == 1:
		set_attack_2()
	
	sprite_result.visible = false
	sprite_multiplicator.visible = true
	visible = true
	angle = 0
	current_level = 0
	hit_count = 0
	crit_count = 0
	randomize()
	set_circle()
	is_active = true
	Utils.sleep(0.5)
	rotating = true


func _ready() -> void:
	visible = false


func result(value: HitType) -> void:
	rotating = false
	match value:
		HitType.MISS:
			await show_result(0)
			end_run()
		HitType.HIT :
			hit_count += 1
			await show_result(1)
			end_run()
		HitType.CRIT:
			hit_count += 1
			crit_count += 1
			await show_result(2)
			next_round()


func end_run() -> void:
	is_active = false
	if hit_count == 0:
		return_multiplier.emit(0.5)
		return
	
	var base_multiplier: float = multipliers[hit_count-1]
	
	# Se acertou todos os críticos, adiciona mais 0.5 no multiplicador (totalizando 2.5)
	if crit_count == 5:
		base_multiplier += 0.5
	
	return_multiplier.emit(base_multiplier)
	pass


func show_result(frame: int):
	sprite_multiplicator.visible = false
	sprite_result.frame = frame
	sprite_result.visible = true
	await Utils.sleep(0.5)


func _process(delta):
	if rotating:
		angle += deg_to_rad(rotation_speed) * delta

		if angle >= TAU:
			angle -= TAU
			#_on_lap_completed()

		queue_redraw()
 

#func _on_lap_completed():
	#if current_level < green_sizes.size() - 1:
		#current_level += 1
		#set_circle()
	#else:
		#result(HitType.MISS)


func set_angle() -> void:
	sector_start_angle = randf_range(PI, PI * 2)

func set_circle() -> void:
	set_angle()
	sprite_multiplicator.frame = current_level
	rotation_speed = rotation_speeds[current_level]
	green_size_deg = green_sizes[current_level]
	yellow_size_deg = yellow_sizes[current_level]

func check_result():
	rotating = false
	var line_angle = fposmod(angle, TAU)

	var green_start = sector_start_angle
	var green_end = sector_start_angle + deg_to_rad(green_size_deg)

	var yellow_left_start = green_start - deg_to_rad(yellow_size_deg)
	var yellow_left_end = green_start

	var yellow_right_start = green_end
	var yellow_right_end = green_end + deg_to_rad(yellow_size_deg)

	yellow_left_start  = minus_tau(yellow_left_start)
	yellow_left_end    = minus_tau(yellow_left_end)
	green_start        = minus_tau(green_start)
	green_end          = minus_tau(green_end)
	yellow_right_start = minus_tau(yellow_right_start)
	yellow_right_end   = minus_tau(yellow_right_end)

	if Utils.in_range(green_start, green_end, line_angle):
		result(HitType.CRIT)
	elif Utils.in_range(yellow_left_start, yellow_left_end, line_angle) \
	or Utils.in_range(yellow_right_start, yellow_right_end, line_angle):
		result(HitType.HIT)
	else:
		result(HitType.MISS)

func minus_tau(value: float) -> float:
	if value >= TAU:
		return value - TAU
	return value

func _input(event):
	if !is_active:
		rotating = false
		return
	
	if rotating and event.is_action_pressed("ui_accept"):
		check_result()

func _draw():
	# área amarela esquerda
	draw_sector(
		Vector2.ZERO,
		radius,
		sector_start_angle - deg_to_rad(yellow_size_deg),
		deg_to_rad(yellow_size_deg),
		Color.YELLOW
	)

	# área verde principal
	draw_sector(
		Vector2.ZERO,
		radius,
		sector_start_angle,
		deg_to_rad(green_size_deg),
		Color(0, 1, 0, 0.5)
	)

	# área amarela direita
	draw_sector(
		Vector2.ZERO,
		radius,
		sector_start_angle + deg_to_rad(green_size_deg),
		deg_to_rad(yellow_size_deg),
		Color.YELLOW
	)
	
	# círculo
	draw_arc(Vector2.ZERO, radius, 0, TAU, 64, Color.DARK_RED, 5)
	
	var end_point: Vector2
	# linha superior
	#end_point = BASE_DIR.rotated(deg_to_rad(0)) * radius
	#draw_line(Vector2.ZERO, end_point, Color.DARK_RED, 5)
	
	# linha movimentada
	end_point = BASE_DIR.rotated(angle) * radius
	draw_line(Vector2.ZERO, end_point, Color.GREEN, 5)


func draw_sector(center: Vector2, l_radius: float, start_angle: float, arc_size: float, color: Color):
	var points: PackedVector2Array = [center]

	var steps := 32

	for i in range(steps + 1):
		var t = float(i) / steps
		var l_angle = start_angle + (arc_size * t)
		points.append(center + BASE_DIR.rotated(l_angle) * l_radius)

	draw_colored_polygon(points, color)
