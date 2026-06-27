extends Node2D

@onready var strength_meter: StrengthMeter = $StrengthMeter

func _ready() -> void:
	strength_meter.activate()
