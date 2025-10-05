class_name GameManager
extends Node

@onready var state_machine: StateMachine = $StateMachine
@export var gui: GUIManager

# ===== Gameplay Variables ===== #
var money = 100000
var crew_capacity = 0
var crew_size = 0

func _ready():
	handle_ui_signals()
	gui.set_money(money)
	gui.set_crew(crew_size, crew_capacity)
	state_machine.state_changed.connect(_on_state_changed)

func _process(_delta):
	pass

# Listen to state machine transitions to update UI
func _on_state_changed(old_state: String, new_state: String):
	var is_building = new_state == "buildingmode"
	gui.set_build_button_state(is_building)

func can_afford(price: int) -> bool:
	return price < money

# ===== UI Handlers ===== #
func handle_ui_signals():
	gui.toggle_build_pressed.connect(_on_toggle_build)
	
	gui.dorm_button_pressed.connect(_on_dorm_button_pressed)
	gui.kitchen_button_pressed.connect(_on_kitchen_button_pressed)
	gui.gym_button_pressed.connect(_on_gym_button_pressed)
	gui.lab_button_pressed.connect(_on_lab_button_pressed)
	gui.hub_comms_button_pressed.connect(_on_hub_comms_button_pressed)
	gui.storage_button_pressed.connect(_on_storage_button_pressed)

func _on_toggle_build():
	if state_machine.current_state_name == "gameplay":
		state_machine.transition_to("BuildingMode")
	else:
		state_machine.transition_to("Gameplay")
		
func _on_dorm_button_pressed():
	if state_machine.current_state_name == "BuildingMode".to_lower():
		(state_machine.current_state as BuildingModeState).selected_module = DataTypes.Module.SleepingArea

func _on_kitchen_button_pressed():
	if state_machine.current_state_name == "BuildingMode".to_lower():
		(state_machine.current_state as BuildingModeState).selected_module = DataTypes.Module.Kitchen

func _on_gym_button_pressed():
	if state_machine.current_state_name == "BuildingMode".to_lower():
		(state_machine.current_state as BuildingModeState).selected_module = DataTypes.Module.Gym

func _on_lab_button_pressed():
	if state_machine.current_state_name == "BuildingMode".to_lower():
		(state_machine.current_state as BuildingModeState).selected_module = DataTypes.Module.Lab

func _on_hub_comms_button_pressed():
	if state_machine.current_state_name == "BuildingMode".to_lower():
		(state_machine.current_state as BuildingModeState).selected_module = DataTypes.Module.Hub_Comms

func _on_storage_button_pressed():
	if state_machine.current_state_name == "BuildingMode".to_lower():
		(state_machine.current_state as BuildingModeState).selected_module = DataTypes.Module.Storage


func _on_building_mode_place_module(module: DataTypes.Module, module_scene: PackedScene, position: Vector2, rotation: float) -> void:
	money = money - DataTypes.get_price(module)
	gui.set_money(money)
	if module == DataTypes.Module.SleepingArea:
		crew_capacity += 2
		gui.set_crew(crew_size, crew_capacity)
