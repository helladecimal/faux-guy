extends Camera2D

@onready var player: Player = get_tree().current_scene.get_node("Player")
@onready var rayL: RayCast2D = player.get_node("BoundsCheckL")
@onready var rayR: RayCast2D = player.get_node("BoundsCheckR")

@export var bounds = 2
@export var tileSize = 32
@onready var camTileSizeX: int = (get_viewport_rect().size.x / tileSize) / zoom.x # should be 20 tiles
@onready var camTileSizeY: int = (get_viewport_rect().size.y / tileSize) / zoom.y # should be 15 tiles

@onready var start_pos_x = get_viewport_rect().get_center().x
@onready var start_pos_y = get_viewport_rect().get_center().y

var rawPlayertilePosX = 0
var rawPlayertilePosY = 0

var playerTilePosX = 0
var playerTilePosY = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(camTileSizeY)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	rawPlayertilePosX = (int)(player.position.x / tileSize) # Raw player position divided by 32, truncated.
	rawPlayertilePosY = (int)(player.position.y / tileSize)
	
	playerTilePosX = abs(rawPlayertilePosX % camTileSizeX) # Tile position that loops over at screen tile size and abs'd.
	playerTilePosY = abs(rawPlayertilePosY % camTileSizeY)
	
	var camLockPos = (start_pos_x/2 * sign(rawPlayertilePosX)) + start_pos_x * (rawPlayertilePosX / camTileSizeX) # Hellish formula for screen position
	
	if (bounds > playerTilePosX or (camTileSizeX - bounds - 1) < playerTilePosX) and (!rayL.is_colliding() and !rayR.is_colliding()):
		position.x = player.position.x
	else:
		position.x = camLockPos
	
		
		
