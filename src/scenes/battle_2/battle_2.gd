class_name Battle2 extends BaseBattle

@onready var boss: Boss2 = $Boss
@onready var player_battle: PlayerBattle = $PlayerBattle

func _ready() -> void:
	super()
	start_fight.call_deferred()

func use_item() -> void:
	Global.potions_in_inventory -= 1
	player_battle.heal(Global.health_to_append)
	update_items()
	
	change_turn()

func define_attacks() -> void:
	for i in range(0, player_battle.attacks.size()):
		add_attack(player_battle.attacks[i].attack_name)
	set_go_back(attack_selection)

func start_fight() -> void:
	define_attacks()
	health_bar_boss.set_health_component(boss.health_component)
	health_bar_player.set_health_component(player_battle.health_component)

func attack(index: int) -> void:
	player_battle.play_attack()
	player_frame.pause_animation()

	strength_meter.activate()

	var multiplier: float = await strength_meter.return_multiplier

	strength_meter.hide()


	if player_battle.attacks.size() > 0:
		var current_attack = player_battle.attacks[index]

		current_attack.multiplier = multiplier
		await  run_attack(current_attack, boss)


	# for attack in player_battle.attacks:
	# 	if attack is AttackYoyo:
	# 		attack.multiplier = multiplier
	# 		await run_attack(attack, boss)
	#
	#		break
	player_battle.resume_animation()
	player_frame.resume_animation()
	change_turn()

func start_boss_turn() -> void:
	await super()
	for attack in boss.attacks_array:
		if attack is AttackBoss2:
			await run_attack(attack, player_battle)

			break
	change_turn()

func run_attack(attack: BaseAttack, target: Entity) -> void:
	attack.target = target
	attack.execute()

	await attack.attack_finished
	attack_finished.emit()

func _on_boss_is_dead() -> void:
	await attack_finished
	SceneManager.change_scene(self, 'dungeon_floor_2')

func _on_player_battle_is_dead() -> void:
	await attack_finished
	SceneManager.change_scene(self, 'hub_1')
