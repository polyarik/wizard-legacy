class_name MagicMissile

extends Area2D


var speed := 1.2
var direction := Vector2.ZERO


func _ready():
	# TODO - detect the nearest enemy and set direction
	direction = Vector2(-1, -1).normalized() # TEMP

func _physics_process(_delta: float) -> void:
	position += direction * speed