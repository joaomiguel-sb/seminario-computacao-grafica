extends Node

var current_checkpoint_position := Vector2.ZERO


func set_checkpoint(position: Vector2) -> void:
	current_checkpoint_position = position


func get_checkpoint() -> Vector2:
	return current_checkpoint_position
