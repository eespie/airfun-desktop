@tool
extends Node

var current_scene: Node

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
	_bind_events()
	
func _bind_events() -> void:
	EventBus.sigChangeScene.connect(_on_change_scene, CONNECT_DEFERRED)

func _on_change_scene(path: String) -> void:
	var s = ResourceLoader.load(path)
	if s == null:
		return
	current_scene.queue_free()
	current_scene = s.instantiate()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene( current_scene )

func cleanup_group(group_name):
	var nodes = get_tree().get_nodes_in_group(group_name)
	for node in nodes:
		node.queue_free()
