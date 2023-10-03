@icon("res://addons/gdsplash/img/splashicon.svg")
class_name Splash
extends CanvasLayer

enum TYPE {TIMED, SIGNAL}
## Defines how the Splash Screen runs. If it's timed, then the splash screen
## finishes when [code]timer[/code] finishes its countdown. If it's set to
## signal, then it bases its length on when the [code]done[/code] signal is emitted.
@export var type : TYPE = TYPE.TIMED
## Defines the length of the splash screen when in timer mode.
@export var timer : float = 1.0

## Defines the type of transition that should be used to move into this splash.
## Looks into the array of shaders in the SplashContainer parent, and uses that
## transition to move out of the previous splash, and into this one.
@export var transition_type : int
@export var transition_length : float = 0.5

signal done

func _ready() -> void:
	if not get_parent().is_class("SplashContainer"):
		push_error("GdSplash: Splash node will not work if not a child of SplashContainer.")
		return

## If you want to have a small scene display, create a method called "display"
## in the scene, that should take no arguments. It should be an async function
## (aka coroutine), that returns when it's done displaying.
func display() -> void:
	if type == TYPE.TIMED:
		await get_tree().create_timer(timer).timeout
	else:
		if get_child(0).has_method("display"):
			await get_child(0).display()
	emit_signal("done")
