extends ColorRect
class_name PopUpBattleEnd


@export var _message: RichTextLabel
@export var _button: Button

func _ready():
	_button.pressed.connect(_reset_scene)


func show_result(message: String):
	_message.text = "[font_size={45}][center]"+message+"[/center]"
	show()

func _reset_scene():
	get_tree().reload_current_scene()
