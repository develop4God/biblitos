extends Node

signal all_animals_placed

const ANIMALS := ["lion", "elephant", "giraffe", "dove", "sheep", "noah"]

var _placed := {}

func _ready() -> void:
    reset()

func place_animal(animal_key: String) -> void:
    if animal_key in ANIMALS:
        _placed[animal_key] = true
        if all_placed():
            all_animals_placed.emit()

func is_placed(animal_key: String) -> bool:
    return _placed.get(animal_key, false)

func all_placed() -> bool:
    for animal in ANIMALS:
        if not _placed.get(animal, false):
            return false
    return true

func reset() -> void:
    _placed = {}
