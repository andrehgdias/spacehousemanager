class_name GUIManager
extends CanvasLayer

@onready var ui_audio_stream_player: AudioStreamPlayer = %UIAudioStreamPlayer

@export var game_manager: GameManager

signal toggle_build_pressed
signal dorm_button_pressed
signal kitchen_button_pressed
signal gym_button_pressed
signal lab_button_pressed
signal hub_comms_button_pressed
signal storage_button_pressed

@onready var day_label: Label = %DayLabel
@onready var crew_counter: Label = %CrewCounter
@onready var funding_label: Label = %FundingLabel

@onready var mission_panel: PanelContainer = $MarginContainer/MissionPanel
@onready var mission_label: Label = %MissionLabel
@onready var mission_count_down_label: Label = %MissionCountDownLabel
@onready var mission_effect_label: Label = %MissionEffectLabel
@onready var mission_payment_label: Label = %MissionPaymentLabel

@onready var build_button: Button = %BuildButton
@onready var dorm_button: Button = $MarginContainer/TopRight/ShapesContainer/DormButton
@onready var kitchen_button: Button = $MarginContainer/TopRight/ShapesContainer/KitchenButton
@onready var gym_button: Button = $MarginContainer/TopRight/ShapesContainer/GymButton
@onready var lab_button: Button = $MarginContainer/TopRight/ShapesContainer/LabButton
@onready var hub_comms_button: Button = $MarginContainer/TopRight/ShapesContainer/HubCommsButton
@onready var storage_button: Button = $MarginContainer/TopRight/ShapesContainer/StorageButton

@onready var shapes_container: VBoxContainer = %ShapesContainer
@onready var details_popup_panel: PopupPanel = %DetailsPopupPanel
@onready var title_label: Label = %TitleLabel
@onready var price_label: Label = %PriceLabel
@onready var details_text: RichTextLabel = %DetailsText

var padding = 32

func _ready():
	build_button.pressed.connect(_on_build_button_pressed)
	
	dorm_button.pressed.connect(_on_dorm_button_pressed)
	dorm_button.mouse_entered.connect(_on_dorm_button_mouse_entered)
	dorm_button.mouse_exited.connect(_on_dorm_button_mouse_exited)
	
	kitchen_button.pressed.connect(_on_kitchen_button_pressed)
	kitchen_button.mouse_entered.connect(_on_kitchen_button_mouse_entered)
	kitchen_button.mouse_exited.connect(_on_kitchen_button_mouse_exited)
	
	gym_button.pressed.connect(_on_gym_button_pressed)
	gym_button.mouse_entered.connect(_on_gym_button_mouse_entered)
	gym_button.mouse_exited.connect(_on_gym_button_mouse_exited)
	
	lab_button.pressed.connect(_on_lab_button_pressed)
	lab_button.mouse_entered.connect(_on_lab_button_mouse_entered)
	lab_button.mouse_exited.connect(_on_lab_button_mouse_exited)
	
	hub_comms_button.pressed.connect(_on_hub_comms_button_pressed)
	hub_comms_button.mouse_entered.connect(_on_hub_comms_button_mouse_entered)
	hub_comms_button.mouse_exited.connect(_on_hub_comms_button_mouse_exited)
	
	storage_button.pressed.connect(_on_storage_button_pressed)
	storage_button.mouse_entered.connect(_on_storage_button_mouse_entered)
	storage_button.mouse_exited.connect(_on_storage_button_mouse_exited)
	
	shapes_container.visible = false

func _process(delta: float) -> void:
	handle_button_states()

func _on_build_button_pressed():
	emit_signal("toggle_build_pressed")

# ===== Dormitory ===== #
func _on_dorm_button_pressed():
	emit_signal("dorm_button_pressed")
func _on_dorm_button_mouse_entered():
	var data = DataTypes.Data.get(DataTypes.Module.SleepingArea)
	show_popup(dorm_button.global_position, data.title, data.description, data.price)
func _on_dorm_button_mouse_exited():
	details_popup_panel.hide()

# ===== Kitchen  ===== #
func _on_kitchen_button_pressed():
	emit_signal("kitchen_button_pressed")
func _on_kitchen_button_mouse_entered():
	var data = DataTypes.Data.get(DataTypes.Module.Kitchen)
	show_popup(dorm_button.global_position, data.title, data.description, data.price)
func _on_kitchen_button_mouse_exited():
	details_popup_panel.hide()

# ===== Gym ===== #
func _on_gym_button_pressed():
	emit_signal("gym_button_pressed")
func _on_gym_button_mouse_entered():
	var data = DataTypes.Data.get(DataTypes.Module.Gym)
	show_popup(gym_button.global_position, data.title, data.description, data.price)
func _on_gym_button_mouse_exited():
	details_popup_panel.hide()

# ===== Lab ===== #
func _on_lab_button_pressed():
	emit_signal("lab_button_pressed")
func _on_lab_button_mouse_entered():
	var data = DataTypes.Data.get(DataTypes.Module.Lab)
	show_popup(gym_button.global_position, data.title, data.description, data.price)
func _on_lab_button_mouse_exited():
	details_popup_panel.hide()

# ===== Hub-Comms ===== #
func _on_hub_comms_button_pressed():
	emit_signal("hub_comms_button_pressed")
func _on_hub_comms_button_mouse_entered():
	var data = DataTypes.Data.get(DataTypes.Module.Hub_Comms)
	show_popup(gym_button.global_position, data.title, data.description, data.price)
func _on_hub_comms_button_mouse_exited():
	details_popup_panel.hide()

# ===== Storage ===== #
func _on_storage_button_pressed():
	emit_signal("storage_button_pressed")
func _on_storage_button_mouse_entered():
	var data = DataTypes.Data.get(DataTypes.Module.Storage)
	show_popup(gym_button.global_position, data.title, data.description, data.price)
func _on_storage_button_mouse_exited():
	details_popup_panel.hide()


# ===== Helpers ===== #
func set_build_button_state(is_building: bool):
	build_button.button_pressed = is_building
	
	if is_building:
		build_button.text = "X"
		shapes_container.visible = true
	else:
		build_button.text = "Build"
		shapes_container.visible = false
		
func show_popup(origin_position: Vector2i, title: String, description: String, price: int):
	details_popup_panel.set_position(Vector2(origin_position.x - details_popup_panel.get_size_with_decorations().x - padding, origin_position.y))
	title_label.text = title
	details_text.text = description
	price_label.text = "$ %d" % price
	details_popup_panel.reset_size()
	details_popup_panel.popup()
	
func handle_button_states():
	dorm_button.disabled = !game_manager.can_afford(DataTypes.get_price(DataTypes.Module.SleepingArea))
	kitchen_button.disabled = !game_manager.can_afford(DataTypes.get_price(DataTypes.Module.Kitchen))
	gym_button.disabled = !game_manager.can_afford(DataTypes.get_price(DataTypes.Module.Gym))
	lab_button.disabled = !game_manager.can_afford(DataTypes.get_price(DataTypes.Module.Lab))
	storage_button.disabled = !game_manager.can_afford(DataTypes.get_price(DataTypes.Module.Storage))
	
func set_money(money: int):
	funding_label.text = "$ %d" % money

func set_crew(crew_size: int, crew_capacity: int):
	crew_counter.text = "Crew %d/%d" % [ crew_size, crew_capacity ]

func set_day(day: int):
	day_label.text = "Day %d" % day

func disable_hub_comms_button():
	hub_comms_button.disabled = true

func update_mission_panel(mission: Dictionary, countdown: int):
	if mission == {}:
		print("No mission")
		mission_panel.visible = false
	else:
		mission_panel.visible = true
		mission_label.text = mission.name
		mission_count_down_label.text = "Arrives in %d days" % countdown
		if (mission.crew_change > 0):
			mission_effect_label.text = "+%d Crew" % mission.crew_change
		else:
			mission_effect_label.text = "-%d Crew" % mission.crew_change
		
		mission_payment_label.text = "$ %d" % mission.payment
			
		
