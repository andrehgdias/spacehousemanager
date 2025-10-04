class_name StateMachine
extends Node


@export var initial_state: NodeState
var current_state : NodeState
var current_state_name : String

var node_states : Dictionary = {}

signal state_changed(old_state: String, new_state: String)

func _ready() -> void:
	print("State machine ready. Current state: ", initial_state.name)
	for child in get_children():
		if child is NodeState:
			node_states[child.name.to_lower()] = child
			child.transition.connect(transition_to)
			
	if initial_state:
		initial_state._on_enter()
		current_state = initial_state
		current_state_name = current_state.name.to_lower()
		
		
func _process(delta : float) -> void:
	if current_state:
		current_state._on_process(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state._on_physics_process(delta)
		current_state._on_next_transitions()
		

func transition_to(node_state_name : String) -> void:
	if node_state_name == current_state.name.to_lower():
		return
	
	var new_node_state = node_states.get(node_state_name.to_lower())
	
	if !new_node_state:
		print("Node State '" + node_state_name + "' not found")
		return
	
	if current_state:
		current_state._on_exit()
	
	var old_state_name = current_state_name
	
	new_node_state._on_enter()
	current_state = new_node_state
	current_state_name = new_node_state.name.to_lower()

	print(get_parent().name, ": ", old_state_name, " -> ", current_state_name)
	state_changed.emit(old_state_name, current_state_name)
