extends Control

signal dialog_started
signal dialog_finished

var is_open = false

onready var bgRect = $ColorRect
onready var animationPlayer = $ColorRect/AnimationPlayer
onready var textLabel = $RichTextLabel

func _ready():
	textLabel.hide()
	bgRect.rect_size.y = 0

func _input(event):
	if event is InputEventKey and event.pressed and not event.is_echo() and is_open:
		animationPlayer.play("DialogClose")

func _on_AnimationPlayer_animation_started(anim_name):
	match anim_name:
		"DialogClose":
			is_open = false
		"DialogOpen":
			emit_signal("dialog_started")

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"DialogClose":
			emit_signal("dialog_finished")
			queue_free()
		"DialogOpen":
			is_open = true

func _on_Timer_timeout():
	animationPlayer.play("DialogOpen")
