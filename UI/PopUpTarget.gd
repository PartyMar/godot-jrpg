extends ColorRect
class_name PopUpTarget

@export var _targets_grid: GridContainer

var _button = preload("res://UI/target_button.tscn")
var _buttons_instances: Array[TargetButton] = []



func show_targets(targets: Array[Fighter], selected: Signal):
	show()
	
	print("\nChoose target!")

	
	for t in targets:
		var trigger_selected = func():
			selected.emit(t)
		
		var b: TargetButton = _button.instantiate()
		b.set_target(t)
		_targets_grid.add_child(b)
		_buttons_instances.append(b)
		b.pressed.connect(hide_targets)
		b.pressed.connect(trigger_selected)
	
	return _buttons_instances


func hide_targets():
	hide()
	_clear_buttons()

func _clear_buttons():
	for b in _buttons_instances:
		b.queue_free()
	_buttons_instances = []
