class_name GUIManager
extends CanvasLayer

signal toggle_build_pressed
signal square_button_pressed
signal rectangle_button_pressed

@onready var build_button: Button = %BuildButton
@onready var square_button: Button = $MarginContainer/PanelContainer/ShapesContainer/SquareButton
@onready var rectangle_button: Button = $MarginContainer/PanelContainer/ShapesContainer/RectangleButton
@onready var shapes_container: VBoxContainer = %ShapesContainer

func _ready():
	build_button.pressed.connect(_on_build_button_pressed)
	square_button.pressed.connect(_on_square_button_pressed)
	rectangle_button.pressed.connect(_on_rectangle_button_pressed)
	shapes_container.visible = false

func _on_build_button_pressed():
	emit_signal("toggle_build_pressed")
	
func _on_square_button_pressed():
	emit_signal("square_button_pressed")
	
func _on_rectangle_button_pressed():
	emit_signal("rectangle_button_pressed")

func set_build_button_state(is_building: bool):
	build_button.button_pressed = is_building
	
	if is_building:
		build_button.text = "X"
		shapes_container.visible = true
	else:
		build_button.text = "Build"
		shapes_container.visible = false
