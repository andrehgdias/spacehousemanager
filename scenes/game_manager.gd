class_name GameManager
extends Node

@onready var state_machine: StateMachine = $StateMachine
@export var gui: GUIManager

# ===== Gameplay Variables ===== #
@export var money = 150000
var crew_capacity = 0
var crew_size = 0
var day = 1

var hub_installed = false
var first_mission_generated = false

var mission_countdown = 0
var current_mission: Dictionary = {}

@export var progressison_tick = 15 # seconds
var last_progression_time = 0 # seconds

@export var names = ["Mission Alpha", "Beta Go", "New Horizon", "Zero Up", "Beyond"]

var time_since_last_mission = 0
@export var min_time_to_mission: float = 60
@export var max_time_to_mission: float = 90

@export var day_duration: float = 180 # seconds
var elapsed_time: float = 0

func _ready():
	handle_ui_signals()
	gui.set_money(money)
	gui.set_crew(crew_size, crew_capacity)
	gui.update_mission_panel(current_mission, mission_countdown)
	state_machine.state_changed.connect(_on_state_changed)

func _process(_delta):
	if(Input.is_action_just_pressed("debug")):
		print("elapsed_time: ", elapsed_time)

# Listen to state machine transitions to update UI
func _on_state_changed(old_state: String, new_state: String):
	var is_building = new_state == "buildingmode"
	gui.set_build_button_state(is_building)

func _on_building_mode_place_module(module: DataTypes.Module, module_scene: PackedScene, position: Vector2, rotation: float) -> void:
	money = money - DataTypes.get_price(module)
	gui.set_money(money)
	
	if module == DataTypes.Module.Hub_Comms:
		hub_installed = true
		gui.disable_hub_comms_button()
		
	if module == DataTypes.Module.SleepingArea:
		crew_capacity += 2
		gui.set_crew(crew_size, crew_capacity)

# ===== Helpers ===== #
func can_afford(price: int) -> bool:
	return price < money
	
func pass_time(delta: float):
	elapsed_time += delta
	
	if current_mission == {}:
		time_since_last_mission += delta
			
	if(elapsed_time >= day_duration):
		_next_day()
	
	handle_events()
	handle_progression(false)

func _next_day():
	elapsed_time = 0
	last_progression_time = 0
	
	day += 1
	gui.set_day(day)
	
	mission_countdown -= 1
	gui.update_mission_panel(current_mission, mission_countdown)
	
	handle_progression(true)

	
func handle_events():
	if current_mission == {}:
		if time_since_last_mission > randf_range(min_time_to_mission, max_time_to_mission):
			generate_mission()
			gui.update_mission_panel(current_mission, mission_countdown)		
	elif current_mission and mission_countdown == 0:
		handle_mission()
	
	# TODO random events?

func handle_progression(is_new_day: bool):
	if is_new_day or elapsed_time >= last_progression_time + progressison_tick:
		var money_gain = 2500 * randi_range(2,5)
		print("Progression: money_gain = ", money_gain)
		money += crew_size * money_gain
		last_progression_time = elapsed_time
		gui.set_money(money)
		
func generate_mission():
	print("New mission:")
	time_since_last_mission = 0
	
	if first_mission_generated == false:
		current_mission = {
			"name": "AV One Beyond",
			"crew_change": 2,
			"days_to_arive": 2,
			"payment": 25000
		}
		first_mission_generated = true
	else:
		current_mission = {
			"name": random_mission_name(),
			"crew_change": randi_range(-clampi(randi_range(2, 4),2,crew_size - 2), 4),
			"days_to_arive": randi_range(2,4),
			"payment": randi_range(1,5) * 20000
		}
		
	print(current_mission)
	mission_countdown = current_mission.days_to_arive

func random_mission_name():
	return names.pop_at(randf_range(0, names.size() - 1))
	
func handle_mission():
	print("Handle mission")
	var new_crew_count = crew_size + current_mission.crew_change
	if(new_crew_count <= crew_capacity):
		crew_size = new_crew_count
		money += current_mission.payment
		
		mission_countdown = 0
		current_mission = {}
		
		gui.update_mission_panel(current_mission, mission_countdown)
		gui.set_crew(crew_size, crew_capacity)
		gui.set_money(money)
	else:
		print("Not enough capacity")
		# TODO endgame
		# Wait another 2 days and check again



	
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
