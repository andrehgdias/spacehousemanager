class_name BuildingModeState
extends NodeState

const CURSOR_BUILD = preload("res://assets/tile_0110.png")
const CURSOR_NORMAL = preload("res://assets/tile_0086.png")

@onready var module_dorms_scene: PackedScene = preload("res://scenes/modules/dorm.tscn")
@onready var module_kitchen_scene: PackedScene = preload("res://scenes/modules/kitchen.tscn")
@onready var module_gym_scene: PackedScene = preload("res://scenes/modules/gym.tscn")
@onready var module_lab_scene: PackedScene = preload("res://scenes/modules/laboratory.tscn")
@onready var module_hub_comms_scene: PackedScene = preload("res://scenes/modules/hub-comms.tscn")
@onready var module_storage_scene: PackedScene = preload("res://scenes/modules/storage.tscn")
@onready var scenes: Dictionary = {
	DataTypes.Module.SleepingArea: module_dorms_scene,
	DataTypes.Module.Kitchen: module_kitchen_scene,
	DataTypes.Module.Gym: module_gym_scene,
	DataTypes.Module.Lab: module_lab_scene,
	DataTypes.Module.Hub_Comms: module_hub_comms_scene,
	DataTypes.Module.Storage: module_storage_scene,
}

@export var grid_root: GridRoot

var selected_module: DataTypes.Module = DataTypes.Module.None
var module: Node2D = null

signal place_module(module: DataTypes.Module, module_scene: PackedScene, position: Vector2, rotation: float)

@export var music: AudioStream
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

func _on_enter() -> void:
	audio_stream_player.stream = music
	audio_stream_player.play()
	reset_building_state()

func _on_process(_delta : float) -> void:
	handle_input()
	update_module_preview()

func _on_physics_process(_delta : float) -> void:
	pass
	
func _on_next_transitions() -> void:
	pass

func _on_exit() -> void:
	reset_building_state()

func reset_building_state():
	Input.set_custom_mouse_cursor(CURSOR_NORMAL)
	selected_module = DataTypes.Module.None
	if module:
		module.queue_free()
		module = null
		
func handle_input():
	if(Input.is_action_just_released("cancel_deploying")):
		reset_building_state()
		
	if Input.is_action_just_pressed("rotate_module") and module:
		module.rotation += deg_to_rad(90)
			
	if Input.is_action_just_pressed("place_module") and module:
		place_module.emit(selected_module, scenes.get(selected_module), module.position, module.rotation)
		call_deferred("reset_building_state")	
		
func update_module_preview():
	if module:
		# Snap preview position to grid
		var mouse_world_pos = get_viewport().get_mouse_position()
		mouse_world_pos = get_viewport().get_camera_2d().get_global_mouse_position()
		module.global_position = grid_root.snap_to_grid(mouse_world_pos)
		
	if module == null and selected_module != DataTypes.Module.None:
		Input.set_custom_mouse_cursor(CURSOR_BUILD)
		# Instantiate ghost preview
		module = scenes.get(selected_module).instantiate()
		module.modulate.a = 0.35
		grid_root.add_child(module)
