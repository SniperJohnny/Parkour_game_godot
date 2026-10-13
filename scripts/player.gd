extends Area2D

@export var speed = 100
@export var current_gravity_constant = 98.7
var currentgravityapplied 
@export var startinggravity = 9.87
var maxgravityapplied = 59987
@export var jumppower = -100
@export var ground_offset: float = 0.05  # adjust to match your character
@export var step_height: float = 8.0      # max pixels the player can auto-climb
@export var player_half_width: float = 4.0  # half the collision shape width
@export var player_half_height: float = 8.0 # half the collision shape height
var space_state
var velocity = Vector2.ZERO
var move_velocity = Vector2.ZERO
var is_on_ground
var lastvalidpos = Vector2.ZERO



var query_forward = PhysicsRayQueryParameters2D.create(
		global_position,                          # from
		global_position + Vector2(5, -5),          # to (5 pixels below)
		2147483648                                      # collision_mask (layer 32)
)

var query_backwards = PhysicsRayQueryParameters2D.create(
		global_position,                          # from
		global_position + Vector2(-5, -5),          # to (5 pixels below)
		2147483648                                      # collision_mask (layer 32)
)

var query_forward_slide = PhysicsRayQueryParameters2D.create(
		global_position,                          # from
		global_position + Vector2(5, -5),          # to (5 pixels below)
		2147483648                                      # collision_mask (layer 32)
)

var query_backwards_slide = PhysicsRayQueryParameters2D.create(
		global_position,                          # from
		global_position + Vector2(-5, -5),          # to (5 pixels below)
		2147483648                                      # collision_mask (layer 32)
)

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


	var query_forward = PhysicsRayQueryParameters2D.create(
			global_position,                          # from
			global_position + Vector2(5, -5),          # to (5 pixels below)
			2147483648                                      # collision_mask (layer 32)
	)

	var query_backwards = PhysicsRayQueryParameters2D.create(
		global_position,                          # from
		global_position + Vector2(-5, -5),          # to (5 pixels below)
		2147483648                                      # collision_mask (layer 32)
	)

	var query_forward_slide = PhysicsRayQueryParameters2D.create(
		global_position,                          # from
		global_position + Vector2(5, 0),          # to (5 pixels below)
			1073741824                                      # collision_mask (layer 32)
	)

	var query_backwards_slide = PhysicsRayQueryParameters2D.create(
		global_position,                          # from
		global_position + Vector2(-5, 0),          # to (5 pixels below)
			1073741824                                   # collision_mask (layer 32)
	)
	query_forward.exclude = [self]
	var result_forward = space_state.intersect_ray(query_forward)
	if(result_forward):
		global_position.x = lastvalidpos.x

		
	
	query_backwards.exclude = [self]
	var result_backward = space_state.intersect_ray(query_backwards)
	if(result_backward):
		global_position.x = lastvalidpos.x

		
	
	query_forward_slide.exclude = [self]
	var result_forward_slide = space_state.intersect_ray(query_forward_slide)
	if(result_forward_slide):
		global_position.y = result_forward_slide.position.y - ground_offset

		
	
	query_backwards_slide.exclude = [self]
	var result_backwards_slide = space_state.intersect_ray(query_backwards_slide)
	if(result_backwards_slide):
		global_position.y = result_backwards_slide.position.y - ground_offset

		
	lastvalidpos.x = global_position.x
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_gravity(delta)
	_movement(delta)
	
	
	
	pass
