@icon("res://addons/gdsplash/img/splashcontainericon.svg")
class_name SplashContainer
extends CanvasLayer

signal splashes_done

## All of the different transitions that can be used for the splashes. Expects
## each shader to have an [code]intensity[/code] parameter that ranges from
## [code]0[/code] to [code]1[/code], with 0 being no effect, and 1 being fully
## applied.
@export var transitions : Array[Shader]

var splashes : Array[Splash]
var splash_index := 0

var shader_overlay : ColorRect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	layer = 127
	splashes = get_splash_children()
	shader_overlay = ColorRect.new()
	add_child(shader_overlay)
	shader_overlay.position = Vector2.ZERO
	shader_overlay.size = Vector2(ProjectSettings.get_setting("display/width"), ProjectSettings.get_setting("display/height"))


func start() -> void:
	splash_index = 0
	next_splash()


func connect_splashes() -> void:
	for spl in splashes:
		spl.done.connect(next_splash)


func next_splash() -> void:
	await transition_out()
	if not splash_index >= splashes.size() - 1:
		transition_in()
	else:
		emit_signal("splashes_done")


func transition_out() -> void:
	if not splash_index >= splashes.size() - 1:
		splash_index += 1
	shader_overlay.material = ShaderMaterial.new()
	shader_overlay.material.shader = transitions[splashes[splash_index].transition_type % transitions.size()]
	shader_overlay.material.set_shader_parameter("intensity", 0)
	var tween = get_tree().create_tween()
	await tween.tween_method(
		shader_overlay.material.set_shader_parameter, 
		0, 1, 
		splashes[splash_index].transition_length/2.0
		)
	splashes[splash_index - 1].hide()


func transition_in() -> void:
	splashes[splash_index].show()
	var tween = get_tree().create_tween()
	await tween.tween_method(
		shader_overlay.material.set_shader_parameter,
		1, 0,
		splashes[splash_index].transition_length/2.0
	)
	splashes[splash_index].display()


func get_splash_children() -> Array[Splash]:
	var children := get_children()
	var spl : Array[Splash]
	
	for child in children:
		if child.is_class("Splash"):
			spl.append(child)
	
	return spl
	
