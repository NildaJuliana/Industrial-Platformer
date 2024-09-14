extends Sprite2D

class_name Spikes

var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (player):
		player.take_damage(self)


func _on_area_2d_body_entered(body: Node2D):
	if body is Player:
		player = body as Player


func _on_area_2d_body_exited(body: Node2D):
	if body is Player:
		player = null
