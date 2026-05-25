extends CanvasLayer

@onready var gameover = $Center/GameOver
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player: Player = get_tree().current_scene.find_child("Player")
	if player:
		player.died.connect(_on_death)
		player.restart.connect(_on_restart)

func _on_death():
	gameover.visible = true

func _on_restart():
	gameover.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
