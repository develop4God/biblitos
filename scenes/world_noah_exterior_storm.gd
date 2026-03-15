extends Node2D

func _ready() -> void:
	$UI/LanguageButton.pressed.connect(_on_language_button_pressed)

func _on_language_button_pressed() -> void:
	var languages := ["en", "es", "pt", "fr"]
	var current := languages.find(LocaleManager.current_language)
	var next: String = languages[(current + 1) % languages.size()]
	LocaleManager.set_language(next)
