extends Sprite

const MIN_SPEED = 15
const MAX_SPEED = 25

const MIN_WAIT_TIME = 0.1
const MAX_WAIT_TIME = 1

onready var animationPlayer = $AnimationPlayer
onready var tween = $Tween
onready var timer = $Timer

func _ready():
	animationPlayer.play("fly")
	wander()

func _on_Timer_timeout():
	wander()

func wander():
	var wander_point = pick_wander_point()
	var wander_distance = position.distance_to(wander_point)
	var speed = random_wander_speed()
	var duration = wander_distance / speed
	tween.remove_all()
	tween.interpolate_property(self, "position", Vector2(position), wander_point, duration, Tween.TRANS_LINEAR)
	tween.start()
	timer.start(random_wait_time())

func pick_wander_point():
	var x = (randi() % 160) + 1
	var y = (randi() % 150) + 1
	return Vector2(x, y)

func random_wander_speed():
	return (randi() % MAX_SPEED) + MIN_SPEED

func random_wait_time():
	var pct = float(randi() % 10) / 10
	var wait_time = max(MIN_WAIT_TIME, MAX_WAIT_TIME * pct)
	return wait_time
