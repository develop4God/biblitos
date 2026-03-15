extends Node

var _music_player: AudioStreamPlayer
var _sfx_player: AudioStreamPlayer

func _ready() -> void:
    _music_player = AudioStreamPlayer.new()
    add_child(_music_player)
    _sfx_player = AudioStreamPlayer.new()
    add_child(_sfx_player)

func play(audio_key: String) -> void:
    var path := LocaleManager.build_path(audio_key)
    var stream := load(path)
    if stream:
        _music_player.stream = stream
        _music_player.play()
    else:
        push_error("AudioManager: file not found → " + path)

func play_sfx(sfx_key: String) -> void:
    var path := LocaleManager.build_sfx_path(sfx_key)
    var stream := load(path)
    if stream:
        _sfx_player.stream = stream
        _sfx_player.play()
    else:
        push_error("AudioManager: sfx not found → " + path)

func stop() -> void:
    _music_player.stop()
