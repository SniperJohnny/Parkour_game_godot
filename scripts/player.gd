extends Area2D

@export var speed = 100
@export var current_gravity_constant = 98.7
var currentgravityapplied 
@export var startinggravity = 9.87
var maxgravityapplied = 59987
@export var jumppower = -75
@export var ground_offset: float = 0.05  # adjust to match your character
var space_state
var velocity = Vector2.ZERO
var move_velocity = Vector2.ZERO
var is_on_ground
var lastvalidpos = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	space_state= get_world_2d().direct_space_state
	currentgravityapplied = startinggravity
	pass # Replace with function body.

func _gravity(delta) -> void:
	
	if(currentgravityapplied <= maxgravityapplied):
		currentgravityapplied += current_gravity_constant * delta
	elif(currentgravityapplied > maxgravityapplied):
		currentgravityapplied = maxgravityapplied
	var query = PhysicsRayQueryParameters2D.create(
			global_position,                          # from
			global_position + Vector2(0, 4),          # to (5 pixels below)
			2147483648                                      # collision_mask (layer 32)
	)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if(result):
		if(currentgravityapplied >= 0):
			currentgravityapplied = 0
			is_on_ground = true
			global_position.y = result.position.y - ground_offset
			print("is_on_ground)")
			print(result)
			return

	velocity.y = currentgravityapplied 
	position += velocity * delta

func _movement(delta):
	
	
	var direction := 0
	if is_on_ground:
		if(Input.is_action_just_pressed("jump")):
			currentgravityapplied = jumppower
			is_on_ground = false
	if(Input.is_action_pressed("move_left")):
		direction -= 1 
	if(Input.is_action_pressed("move_right")):
		direction += 1 
	move_velocity.x = direction * speed
		
	position += move_velocity * delta

	var query = PhysicsRayQueryParameters2D.create(
			global_position,                          # from
			global_position + Vector2(5, 0),          # to (5 pixels below)
			2147483648                                      # collision_mask (layer 32)
	)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if(result):
		global_position.x = lastvalidpos.x

		print("Hi")
	
	lastvalidpos.x = global_position.x
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_gravity(delta)
	_movement(delta)
	
	
	
	pass
