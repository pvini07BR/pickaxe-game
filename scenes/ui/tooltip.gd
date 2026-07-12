extends PanelContainer

@export var offset_pos := Vector2(15, 15)
@onready var label: Label = $Label

var language_defined := false
var seed := 0

func _ready() -> void:
	hide()

func _process(_delta: float) -> void:
	if visible:
		global_position = get_global_mouse_position() + offset_pos

func show_tooltip(text: String) -> void:
	label.text = text
	size = Vector2.ZERO
	show()

func hide_tooltip() -> void:
	hide()
