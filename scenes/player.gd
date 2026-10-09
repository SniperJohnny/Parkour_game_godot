extends Area2D

@export var speed = 400
@export var current_gravity_constant = -9.87
var currentgravityapplied = -9.87
var space_state 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	space_state= get_world_2d().direct_space_state
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	var query = PhysicsRayQueryParameters2D.create(Vector2(0, 0), Vector2(0, 5))
	var result = space_state.intersect_ray(query)
	query.exclude = [self]
	if(result):
		currentgravityapplied = current_gravity_constant
		print("Hi")
	
	
	
	pass
