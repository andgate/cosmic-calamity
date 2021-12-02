extends KinematicBody2D

const TILE_LENGTH = 16
const MAX_SPEED = 5 * TILE_LENGTH

var current_room_area = null
var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO

signal room_entered(area)

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var tween = $EnterRoomTween
onready var roomDetector = $RoomDetector

onready var playerStart = Vector2(position)

func _ready():
	animationTree.active = true

func update_input_vector():
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

func update_animation_state():
	if input_vector != Vector2.ZERO:
		animationState.travel("Walk")
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)	
	else:
		animationState.travel("Idle")
		
func update_velocity():
	velocity = input_vector * MAX_SPEED

func _physics_process(delta):
	update_input_vector()
	update_animation_state()
	update_velocity()
	velocity = move_and_slide(velocity)

func _on_RoomDetector_area_entered(area):
	area.monitorable = false   # disable monitoring new area
	if not current_room_area:
		current_room_area = area
		return
	# enable monitoring previous area
	current_room_area.monitorable = true
	current_room_area = area
	get_tree().paused = true
	emit_signal("room_entered", area)
	
	calculate_player_start(area)
	tween.interpolate_property(self, "position" , Vector2(position),  playerStart, 0.9, Tween.TRANS_LINEAR)
	tween.start()

func _on_EnterRoomTween_tween_completed(object, key):
	get_tree().paused = false

func calculate_player_start(area):
	var collision_shape = area.get_node("CollisionShape2D")
	var room_extents = collision_shape.shape.extents
	var room_left = collision_shape.global_position.x - room_extents.x
	var room_top = collision_shape.global_position.y - room_extents.x
	var room_right = collision_shape.global_position.x + room_extents.x
	var room_bottom = collision_shape.global_position.y + room_extents.y
	
	var player_extents = Vector2(8, 8)
	var player_left = global_position.x - player_extents.x
	var player_top = global_position.y - player_extents.y
	var player_right = global_position.x + player_extents.x
	var player_bottom = global_position.y + player_extents.y
	
	playerStart.x = position.x
	playerStart.y = position.y
	
	if player_left < room_left:
		playerStart.x = room_left + player_extents.x + 2
	elif player_right > room_right:
		playerStart.x = room_right - (player_extents.x + 2)
	
	if player_top < room_top:
		playerStart.y = room_top + (player_extents.y * 2) + 2
	elif player_bottom > room_bottom:
		playerStart.y = room_bottom - (player_extents.y + 2)
