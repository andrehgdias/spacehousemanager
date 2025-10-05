class_name GridRoot
extends Node2D

@export var grid_size: int = 32

var occupied: Dictionary = {}

func _on_building_mode_place_module(module: DataTypes.Module, module_scene: PackedScene, position: Vector2, rotation: float) -> void:
	place_module(module_scene, position, rotation)

# ===== Helpers ===== #
func place_module(module_scene: PackedScene, position: Vector2, rotation: float):
	var cell = global_position_to_cell(position)
	if occupied.has(cell):
		print("Cell already occupied at ", cell)
		return
	
	var new_module: Node2D = module_scene.instantiate()
	new_module.position = cell * grid_size
	new_module.rotate(rotation)
	add_child(new_module)
	occupied.set(cell, true)

func snap_to_grid(pos: Vector2) -> Vector2:
	return Vector2(
		round(pos.x / grid_size) * grid_size,
		round(pos.y / grid_size) * grid_size
	)

func global_position_to_cell(pos: Vector2) -> Vector2:
	return Vector2(
		round(pos.x / grid_size),
		round(pos.y / grid_size)
	)
