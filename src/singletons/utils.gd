extends Node

# classe global para funções utilitárias que podem ser reutilizadas em diversos momentos do jogo

func in_range(value_1, value_2, value_in) -> bool:
	if value_2 < value_1:
		return value_in >= value_1 or value_in <= value_2
	return value_in >= value_1 and value_in <= value_2

func sleep(time: float):
	if time:
		await get_tree().create_timer(time, false).timeout

func tween_meio_circulo(node: Node2D, target_pos: Vector2, anti_horario: bool, duracao: float):
	var start = node.global_position
	
	var mid = (start + target_pos) / 2
	
	var dir = (target_pos - start).normalized()
	var perp = Vector2(-dir.y, dir.x)
	
	var height = start.distance_to(target_pos) / 2
	if anti_horario:
		mid += perp * height
	else:
		mid -= perp * height
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_method(
		func(t):
			var p = start.lerp(mid, t).lerp(mid.lerp(target_pos, t), t)
			node.global_position = p,
		0.0, 1.0, duracao
	)
	await tween.finished
