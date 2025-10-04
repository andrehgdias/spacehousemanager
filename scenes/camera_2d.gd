extends Camera2D

@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.7
@export var max_zoom: float = 1.3

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_camera(-zoom_speed, event.position)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_camera(zoom_speed, event.position)


func zoom_camera(delta_zoom: float, zoom_center: Vector2):
	var old_zoom = zoom
	var new_zoom = zoom + Vector2(delta_zoom, delta_zoom)
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)

	# Keep zoom centered on the mouse
	var offset = (zoom_center - global_position) * (new_zoom / old_zoom - Vector2(1, 1))
	global_position += offset
	zoom = new_zoom
