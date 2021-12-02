extends KinematicBody2D

const MIN_SPEED = 15
const MAX_SPEED = 25

const MIN_WAIT_TIME = 0.1
const MAX_WAIT_TIME = 1

onready var animationPlayer = $AnimationPlayer
onready var timer = $Timer
onready var player = get_tree().get_nodes_in_group("player")[0]

var velocity = Vector2()

func _ready():
	animationPlayer.play("fly")
	wander()

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	
func _on_Timer_timeout():
	wander()

func wander():
	var wander_direction = (get_random_wander_point() - position).normalized()
	var player_direction = (player.position - position).normalized()
	var speed = random_speed()
	var steer_direction = (2 * wander_direction - player_direction).normalized()
	velocity = steer_direction * speed
	timer.start(random_wait_time())

func get_random_wander_point():
	var x = (randi() % 160) + 1
	var y = (randi() % 150) + 1
	return Vector2(x, y)

func random_speed():
	return (randi() % MAX_SPEED) + MIN_SPEED

func random_wait_time():
	var pct = float(randi() % 10) / 10
	var wait_time = max(MIN_WAIT_TIME, MAX_WAIT_TIME * pct)
	return wait_time
