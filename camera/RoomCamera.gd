extends Position2D

onready var camera = $Camera2D
onready var tween = $CameraSnapTween

var nextPosition = Vector2()

func _ready():
	pass

func _on_Player_room_entered(area):
	var collision_shape = area.get_node("CollisionShape2D")
	var size = collision_shape.shape.extents * 2
	nextPosition = collision_shape.global_position - collision_shape.shape.extents
	
	tween.interpolate_property(self, "position" , Vector2(position),  nextPosition, 0.9, Tween.TRANS_LINEAR)
	tween.start()
