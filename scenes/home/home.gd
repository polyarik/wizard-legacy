class_name Home
extends Node2D

signal home_returned


func _ready() -> void:
	connect_signals()

	emit_signal("home_returned")

	SceneManager.goto_location("test")  # TEMP


func connect_signals() -> void:
	home_returned.connect(DebugPrinter._on_home_returned)
