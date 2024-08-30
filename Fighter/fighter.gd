extends Node
class_name Fighter

@export var health_component: HealthComponent
@export var initiative_component: InitiativeComponent

@export var _health: int = 25
signal knocked

@export var _initiative: int = 8

var team: String = "neutral"

func _ready():
	health_component.set_max(_health)
	initiative_component.set_base(_initiative)
	health_component.reach_zero.connect(_knocked_out)
 

func get_health():
	return health_component
func get_initiative():
	return initiative_component
func attack(target: HealthComponent):
	var damage: int = randi_range(1, 10)
	print(name+" deal "+str(damage)+" damage")
	target.add_number(damage * -1)
	return damage


func _knocked_out():
	print(name+" are out!")
	knocked.emit(self)
