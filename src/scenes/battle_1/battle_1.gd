class_name Battle1 extends BaseBattle

@onready var boss: Boss1 = $Boss
@onready var player_battle: PlayerBattle = $PlayerBattle

func _ready() -> void:
	super()
	start_fight.call_deferred()

func start_fight() -> void:
	health_bar_boss.set_health_component(boss.health_component)
	health_bar_player.set_health_component(player_battle.health_component)

func attack_1() -> void:
	player_battle.pause_animation()
	player_frame.pause_animation()
	
	strength_meter.activate()
	
	var multiplier: float = await strength_meter.return_multiplier
	
	strength_meter.hide()
	
	for attack in player_battle.attacks:
		if attack is AttackYoyo:
			attack.multiplier = multiplier
			await run_attack(attack, boss)
			
			break
	player_battle.resume_animation()
	player_frame.resume_animation()
	change_turn()

func start_boss_turn() -> void:
	await super()
	for attack in boss.attacks_array:
		if attack is AttackBoss1:
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
	SceneManager.change_scene(self, 'dungeon_floor_1')

func _on_player_battle_is_dead() -> void:
	await attack_finished
	SceneManager.change_scene(self, 'dungeon_floor_1')
