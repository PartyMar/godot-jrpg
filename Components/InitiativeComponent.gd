extends Node
class_name InitiativeComponent

@export var _BASE_VALUE:int = 8

var _modified_value: int

func _ready():
	_modified_value = _BASE_VALUE

func get_value():
	return _modified_value

func reset():
	_modified_value = _BASE_VALUE

func set_base(num:int):
	var diff = num - _BASE_VALUE
	_BASE_VALUE = num
	_modified_value += diff

func add_number(num:int):
	_modified_value += num

