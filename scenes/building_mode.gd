class_name BuildingModeState
extends NodeState


@onready var module_square_scene: PackedScene = preload("res://scenes/modules/module_square.tscn")
@onready var module_rectangle_scene: PackedScene = preload("res://scenes/modules/module_rectangle.tscn")
@onready var scenes: Dictionary = {
	DataTypes.Shape.Square: module_square_scene,
	DataTypes.Shape.Rectangle: module_rectangle_scene
}

@export var grid_root: GridRoot

var selected_shape: DataTypes.Shape = DataTypes.Shape.None
var current_module: Node2D = null

signal place_module(module_scene: PackedScene, position: Vector2, rotation: float)

func _on_enter() -> void:
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
	selected_shape = DataTypes.Shape.None
	if current_module:
		current_module.queue_free()
		current_module = null
		
func handle_input():
	if(Input.is_action_just_released("cancel_deploying")):
		reset_building_state()
	
	if(Input.is_action_just_released("debug_module_square") and current_module == null):
		selected_shape = DataTypes.Shape.Square
		
	if(Input.is_action_just_released("debug_module_rectangle") and current_module == null):
		selected_shape = DataTypes.Shape.Rectangle
		
	if Input.is_action_just_pressed("rotate_module") and current_module:
		current_module.rotation += deg_to_rad(90)
			
	if Input.is_action_just_pressed("place_module") and current_module:
		place_module.emit(scenes.get(selected_shape), current_module.position, current_module.rotation)
		call_deferred("reset_building_state")	
		
func update_module_preview():
	if current_module:
		# Snap preview position to grid
		var mouse_world_pos = get_viewport().get_mouse_position()
		mouse_world_pos = get_viewport().get_camera_2d().get_global_mouse_position()
		current_module.global_position = grid_root.snap_to_grid(mouse_world_pos)
		
	if current_module == null and selected_shape != DataTypes.Shape.None:
		# Instantiate ghost preview
		current_module = scenes.get(selected_shape).instantiate()
		current_module.modulate.a = 0.35
		grid_root.add_child(current_module)
