extends Node

@onready var state_machine: StateMachine = $StateMachine
@onready var gui: CanvasLayer = $GUI

func _ready():
	gui.toggle_build_pressed.connect(_on_toggle_build)
	gui.square_button_pressed.connect(_on_square_button_pressed)
	gui.rectangle_button_pressed.connect(_on_rectangle_button_pressed)
	state_machine.state_changed.connect(_on_state_changed)

func _process(_delta):
	# Check for keyboard shortcut
	if Input.is_action_just_released("toggle_build_mode"):
		_on_toggle_build()

func _on_toggle_build():
	if state_machine.current_state_name == "gameplay":
		state_machine.transition_to("BuildingMode")
	else:
		state_machine.transition_to("Gameplay")
		
func _on_square_button_pressed():
	if state_machine.current_state_name == "BuildingMode".to_lower():
		(state_machine.current_state as BuildingModeState).selected_shape = DataTypes.Shape.Square

func _on_rectangle_button_pressed():
	if state_machine.current_state_name == "BuildingMode".to_lower():
		(state_machine.current_state as BuildingModeState).selected_shape = DataTypes.Shape.Rectangle

# Listen to state machine transitions to update UI
func _on_state_changed(old_state: String, new_state: String):
	var is_building = new_state == "buildingmode"
	gui.set_build_button_state(is_building)
