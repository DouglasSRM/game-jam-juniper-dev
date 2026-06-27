extends Node

# PQ AS VARIAVEIS ESTAO TODAS ESPACADAS? kkkkkkkkk

var dialogue_directory: String = "res://data/dialogues/dialogues_en.json"

var option_directory: String = "res://data/options/options_en.json"

var jogo_iniciou: bool = false

var next_battle_scene: String = ""

var current_weapon: PackedScene = null

var potions_in_inventory: int = 3

var health_to_append: float = 5

var teve_dialogos_dungeon_entrance: bool = false
