extends Area2D

@export var speed = 400
@export var current_gravity_constant = 9.87
@export var currentgravityapplied = 9.87
var maxgravityapplied = 599.87
var jumppower = -100
var space_state
var velocity_gravity = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	space_state= get_world_2d().direct_space_state
	pass # Replace with function body.

func _gravity(delta) -> void:
	var query = PhysicsRayQueryParameters2D.create(Vector2(0, 0), Vector2(0, 5))
	var result = space_state.intersect_ray(query)
	query.exclude = [self]
	if(currentgravityapplied <= maxgravityapplied):
		currentgravityapplied = currentgravityapplied * current_gravity_constant 
	elif(currentgravityapplied > maxgravityapplied):
		currentgravityapplied = maxgravityapplied
	if(result):
		if(currentgravityapplied < 0):
			currentgravityapplied = current_gravity_constant

		print("Hi")
	velocity_gravity.y = currentgravityapplied * delta
	position += velocity_gravity * delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_gravity(delta)
	
	
	pass
