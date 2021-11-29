extends Position2D

func _ready():
	$Camera2D.position = Vector2()
	set_as_toplevel(true)

func _on_RoomDetector_area_entered(area):
	var collision_shape = area.get_node("CollisionShape2D")
	var size = collision_shape.shape.extents * 2
	position = collision_shape.global_position - collision_shape.shape.extents
