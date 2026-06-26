class_name BaseBattle extends Node2D

enum Turn {
	PLAYER,
	BOSS
}

@onready var player_frame: PlayerFrame = $PlayerFrame

@onready var action_selection: OptionComponent = $MenuComponents/ActionSelection
@onready var attack_selection: OptionComponent = $MenuComponents/AttackSelection
@onready var item_selection: OptionComponent = $MenuComponents/ItemSelection

@onready var health_bar_boss: HealthBar = $HealthBarBoss
@onready var health_bar_player: HealthBar = $HealthBarPlayer

@onready var strength_meter: StrengthMeter = $StrengthMeter

var active_turn: Turn = Turn.PLAYER

signal attack_finished

func update_items() -> void:
	(item_selection.options[0] as OptionChoice).choice_text.clear()
	(item_selection.options[0] as OptionChoice).choice_function_call.clear()
	set_potions()
	set_go_back(item_selection)

func use_item() -> void:
	pass

func set_potions() -> void:
	for i in range(0, Global.potions_in_inventory):
		var option := OptionFunction.new()
		option.target_path = ("../.." as NodePath)
		option.function_name = "use_item"
		(item_selection.options[0] as OptionChoice).choice_text.append("Health Potion")
		(item_selection.options[0] as OptionChoice).choice_function_call.append(option)

func add_attack(p_name: String) -> void:
	var option := OptionFunction.new()
	option.target_path = ("../.." as NodePath)
	option.function_name = "attack"
	
	var index = (attack_selection.options[0] as OptionChoice).choice_function_call.size()
	option.function_arguments = ([index] as Array[int])
	
	(attack_selection.options[0] as OptionChoice).choice_text.append(p_name)
	(attack_selection.options[0] as OptionChoice).choice_function_call.append(option)


func set_go_back(menu: OptionComponent) -> void:
	var option := OptionFunction.new()
	option.target_path = ("../.." as NodePath)
	option.function_name = "go_back"
	(menu.options[0] as OptionChoice).choice_text.append("Go Back")
	(menu.options[0] as OptionChoice).choice_function_call.append(option)


func _ready() -> void:
	update_items()
	new_turn.call_deferred()


func start_player_turn() -> void:
	activatate_action_selection()

func start_boss_turn() -> void:
	await Utils.sleep(1)

func select_attack() -> void:
	attack_selection.activate_option_box()

func select_item() -> void:
	item_selection.activate_option_box()

func attack(index: int) -> void:
	print(index)

func attack_1() -> void:
	# Implementado na herança
	pass

func attack_2() -> void:
	attack_selection.activate_option_box()

func go_back() -> void:
	activatate_action_selection()

func activatate_action_selection() -> void:
	action_selection.activate_option_box()

func new_turn() -> void:
	if active_turn == Turn.PLAYER:
		start_player_turn()
	else:
		start_boss_turn()

func change_turn() -> void:
	if active_turn == Turn.PLAYER:
		active_turn = Turn.BOSS
	else:
		active_turn = Turn.PLAYER
	
	new_turn()
