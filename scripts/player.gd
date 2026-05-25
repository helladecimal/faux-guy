extends CharacterBody2D
class_name Player

const GRAVITY = 600
var speed = 150
var jump_power = 275
var num_jumps = 2
var alive = true

@onready var coyote = $CoyoteTime
@onready var spawn = position
@onready var _anim = $Kid
@onready var bullet = $Bullet
@onready var blood = $Blood

signal died
signal restart

enum states {Idle, Walk, Fall, Jump}
var current = states.Idle
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

func can_jump():
	
	if is_on_floor() || !coyote.is_stopped():
		num_jumps = 2
		
	
	return num_jumps > 0

func _on_hurtbox_body_entered(body: Node2D) -> void:
	print("lol u died")
	died.emit()
	alive = false
	num_jumps = 0
	blood.position = _anim.position
	blood.emitting = true

func _process(delta: float) -> void:
	
	_anim.visible = alive

	if Input.is_action_just_pressed("Respawn"):
		restart.emit()
		alive = true
		position = spawn
		velocity.x = 0
		velocity.y = 0
		
		blood.restart()
		blood.emitting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.

func animhandle():
	var direction = Input.get_axis("Left", "Right")
	
	
	if current == states.Idle:
		_anim.play("Idle")
	if current == states.Walk:
		_anim.play("Run")
	
	
	if current == states.Fall:
		_anim.play("Fall")
	
	if current == states.Jump:
		_anim.play("Prejump")
		
		_anim.play("Jump")
	
	if velocity.x != 0:
		_anim.flip_h = (direction < 0)
		bullet.flipped = (direction < 0)
	
func physhandle(delta: float):
	velocity.x = 0
	var direction = Input.get_axis("Left", "Right")
	
	if current == states.Fall or current == states.Jump:
		velocity.y += GRAVITY * delta
	
	velocity.x = direction * speed


func _physics_process(delta: float) -> void:
	if not alive:
		return
	
	var direction = Input.get_axis("Left", "Right")
	
	if not is_on_floor():
		current = states.Fall if velocity.y > 0 else states.Jump
		if coyote.is_stopped() and num_jumps == 2:
			num_jumps = 1
	
	if is_on_floor():
		current = states.Idle if direction == 0 else states.Walk
		num_jumps = 2
	
		
	if Input.is_action_just_pressed("Jump") == true and can_jump():
		velocity.y = -jump_power
		num_jumps-=1
		coyote.stop()
	if Input.is_action_just_released("Jump") == true and current == states.Jump:
		velocity.y /= 2
	
	if Input.is_action_just_pressed("Shoot") == true:
		bullet.shoot.emit()
	
	var was_on_floor = is_on_floor()
	physhandle(delta)
	animhandle()
	move_and_slide()
	
	
	if was_on_floor && !is_on_floor():
		coyote.start()
