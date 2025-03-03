extends CharacterBody2D

var player
var chase = false
var SPEED = 50.0
@onready var frog = get_node("AnimatedSprite2D")

func _physics_process(delta):
	# gravity for frog
	if not is_on_floor():
		velocity += get_gravity() * delta
	# makes frog chase 	
	if chase == true:
		if frog.animation != "death":
			frog.play("jump")	
			player = get_node("../../player/player")
			var direction = (player.position - self.position).normalized()
			if direction.x > 0:
				frog.flip_h = true
			elif direction.x < 0:
				frog.flip_h = false
			velocity.x = direction.x * SPEED
	else:
		if frog.animation != "death":
			frog.play("idle")
			velocity.x = 0

	move_and_slide()

func _on_playerdetection_body_entered(body: Node2D) -> void:
	if body.name == "player":
		chase = true


func _on_playerdetection_body_exited(body: Node2D) -> void:
	if body.name == "player":
		chase = false


func _on_playerdeath_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player = get_node("../../player/player")
		player.velocity.y = -250
		death()


func _on_playercollision_body_entered(body: Node2D) -> void:
	if body.name == "player":
		game.player_hp -= 3
		death()

func death():
	velocity.x = 0
	chase = false
	game.gold += 5
	utils.save_game()
	frog.play("death")
	await frog.animation_finished
	self.queue_free()
