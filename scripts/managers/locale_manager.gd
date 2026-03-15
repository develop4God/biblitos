extends Node

signal language_changed(new_language: String)

const SUPPORTED_LANGUAGES := ["en", "es", "pt", "fr"]
const AUDIO_BASE_PATH := "res://assets/audio/"

var current_language: String = "en"

func set_language(language: String) -> void:
    if language in SUPPORTED_LANGUAGES:
        current_language = language
        language_changed.emit(current_language)

func build_path(audio_key: String) -> String:
    return AUDIO_BASE_PATH + current_language + "/" + audio_key + ".mp3"

func build_sfx_path(sfx_key: String) -> String:
    return AUDIO_BASE_PATH + "en/sfx/" + sfx_key + ".mp3"
