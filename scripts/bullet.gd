extends CharacterBody2D
class_name Bullet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

signal shoot

var bullets = []
@onready var hitbox = $Hitbox
var speed = 500
@export var flipped = false

func _on_shoot() -> void:
	if bullets.size() < 6:
		var new = self.duplicate()
		new.global_position = self.global_position
		get_tree().current_scene.add_child(new)
		new.visible = true
		
		new.position.x += -8 if flipped else 8
		new.velocity.x = -speed if flipped else speed
		var bullet_anim: AnimatedSprite2D = new.get_node("BulletSprite")
		bullet_anim.play("Shimmer")
		var time: Timer = new.get_node("DestroyTime")
		bullets.append(new)
		time.start()
	else:
		bullets[0].queue_free()
		bullets.remove_at(0)

func remove(b: Bullet):
	if bullets.find(b) != -1:
		bullets.remove_at(bullets.find(b))
	b.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta: float) -> void:	
	for b: CharacterBody2D in bullets:
		if b != null:
			if b.get_node("DestroyTime").is_stopped():
				print("cooldown stopped")
				remove(b)
			var coll = b.move_and_collide(b.velocity * delta)
			if coll:
				remove(b)

func _process(delta: float) -> void:
	pass
