extends Node

signal scene_changed(scene_name: String)

func go_to(scene_path: String) -> void:
    if ResourceLoader.exists(scene_path):
        scene_changed.emit(scene_path)
        get_tree().change_scene_to_file(scene_path)
    else:
        push_error("SceneManager: scene not found → " + scene_path)
