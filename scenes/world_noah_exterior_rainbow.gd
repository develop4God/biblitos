extends Node2D

func _ready() -> void:
	$UI/LanguageButton.pressed.connect(_on_language_button_pressed)
	GameState.all_animals_placed.connect(_on_all_animals_placed)

func _on_language_button_pressed() -> void:
	var languages := ["en", "es", "pt", "fr"]
	var current := languages.find(LocaleManager.current_language)
	var next := languages[(current + 1) % languages.size()]
	LocaleManager.set_language(next)

func _on_all_animals_placed() -> void:
	AudioManager.play_sfx("rainbow_music")
	SceneManager.go_to("res://scenes/world_noah_interior.tscn")
