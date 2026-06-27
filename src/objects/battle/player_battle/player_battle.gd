class_name PlayerBattle extends Entity

# @onready var attack_yoyo: AttackYoyo = $Attacks/AttackYoyo # N vo comenta pra n dar pau (n olhei ateh onde isso vai), mas n vamos mais usar
@onready var attacks_node: Node2D = $Attacks
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var attacks: Array[BaseAttack]
var current_weapon: BaseWeapon

func _ready() -> void:
	super()
	# attacks.append(attack_yoyo)
	equip_rolled_weapon()
	resume_animation()

func pause_animation() -> void:
	animation_player.stop()

func resume_animation() -> void:
	animation_player.play("idle")

func play_attack() -> void:
	animation_player.play("attacking")

func set_health(value: float) -> void:
	super(value)

func equip_rolled_weapon() ->void:
	if Global.current_weapon:
		current_weapon = Global.current_weapon.instantiate() as BaseWeapon
		attacks_node.add_child(current_weapon)

		# Dogra, viu q eu setei a arma atual como os attacks certo?
		# A gente pode colocar a lista de ataque dentro das armas
		# assim, cada arma tendo uma lista de ataques e soh chamaando o nome delas
		# e as funcoes, quando precisar. Soh uma ideia.

		# Ele vai procurar apenas os ataques de cada arma (wp_1, wp_2..)
		# e vai colocar na lista de ataques
		for child in current_weapon.get_children():
			if child is BaseAttack:
				attacks.append(child)
