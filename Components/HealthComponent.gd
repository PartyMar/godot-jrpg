extends Node
class_name HealthComponent

@export var _MAX_HEALTH: int = 25
var health: int

signal reach_zero

func _ready():
	health = _MAX_HEALTH
	
	
func set_max(value: int):
	_MAX_HEALTH = value
	if health > _MAX_HEALTH: health = _MAX_HEALTH

func add_number(value: int):
	health+=value
	
	if health > _MAX_HEALTH:
		health = _MAX_HEALTH
	elif health <= 0: 
		#health zero, trigger
		health = 0
		reach_zero.emit()
