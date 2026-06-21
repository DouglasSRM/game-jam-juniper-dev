class_name BaseBattle extends Node2D

@onready var action_selection: OptionComponent = $MenuComponents/ActionSelection
@onready var attack_selection: OptionComponent = $MenuComponents/AttackSelection

func select_attack() -> void:
	print('attack')
	attack_selection.activate_option_box()

func select_skill() -> void:
	print('skill')
	action_selection.activate_option_box()

func select_item() -> void:
	print('item')
	action_selection.activate_option_box()

func attack_1() -> void:
	print('attack_1')
	attack_selection.activate_option_box()

func attack_2() -> void:
	print('attack_2')
	attack_selection.activate_option_box()

func go_back() -> void:
	print('go_back')
	action_selection.activate_option_box()
