extends Area2D

@export var audio_key: String = ""
@export var react_animation: String = "react"
@export var idle_animation: String = "idle"
@export var is_draggable: bool = false

func _ready() -> void:
    $AnimationPlayer.play(idle_animation)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event is InputEventScreenTouch and event.pressed:
        _react()

func _react() -> void:
    AudioManager.play(audio_key)
    $AnimationPlayer.play(react_animation)
