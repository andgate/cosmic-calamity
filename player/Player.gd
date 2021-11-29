extends KinematicBody2D

const TILE_LENGTH = 16
const MAX_SPEED = 5 * TILE_LENGTH

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var tween = $Tween

onready var playerStart = Vector2(position)

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationState.travel("Walk")
		velocity = input_vector * MAX_SPEED
	else:
		animationState.travel("Idle")
		velocity = Vector2.ZERO
	
	velocity = move_and_slide(velocity)


func _on_RoomDetector_area_entered(area):
	var collision_shape = area.get_node("CollisionShape2D")
	var room_extents = collision_shape.shape.extents
	var room_left = collision_shape.global_position.x - room_extents.x
	var room_top = collision_shape.global_position.y - room_extents.y
	var room_right = collision_shape.global_position.x + room_extents.x
	var room_bottom = collision_shape.global_position.y + room_extents.y
	
	var player_left = global_position.x - 8
	var player_top = global_position.y - 8
	var player_right = global_position.x + 8
	var player_bottom = global_position.y + 8
	
	playerStart.x = position.x
	playerStart.y = position.y
	
	if player_left < room_left:
		playerStart.x = room_left + 10
	if player_right > room_right:
		playerStart.x = room_right - 10
	if player_top < room_top:
		playerStart.y = room_top + 10
	if player_bottom > room_bottom:
		playerStart.y = room_bottom - 10
		
	tween.interpolate_property($"." , "position" , Vector2(position),  playerStart, 0.2, Tween.TRANS_LINEAR)
	tween.start()