extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim = get_node("AnimationPlayer")
var extra_jumps = 1
var t = 0.0


func _physics_process(delta: float) -> void:
# adds the gravity depending on state
	if not is_on_floor():
# wall jump mechanics, jumps made in separate section
		if is_on_wall():
			extra_jumps = 1
			t += delta * 0.8
			velocity.y = 50 + (150 - 50) * t
			if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
				anim.play("wall-grab-look")
			else:
				anim.play("wall-grab")

# jump only available when pressing direction keys
			if Input.is_action_just_pressed("ui_accept") and (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")):
				if Input.is_action_pressed("ui_right"):
					velocity.x = SPEED
				elif Input.is_action_pressed("ui_left"):
					velocity.x = -SPEED
		else:
			velocity += get_gravity() * delta
			t = 0.0

# handles jumps from floor
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")

# handles jumps in air or from wall
	elif Input.is_action_just_pressed("ui_accept") and not is_on_floor():
		if not (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")) and is_on_wall():
			pass
# if the extra jumps exceed zero then the function may proceed
		elif extra_jumps > 0:
			anim.play("jump")
			if is_on_wall():
				velocity.y = JUMP_VELOCITY/1.2
			else:
				velocity.y = JUMP_VELOCITY
			extra_jumps -= 1

# reset double jumps
	if is_on_floor():
		extra_jumps = 1

# Get the input direction and handle the movement/deceleration.
# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if is_on_wall():
		pass
	elif direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	
	if is_on_wall():
		pass
	else:
		if direction:
			velocity.x = direction * SPEED
			if velocity.y == 0:
				anim.play("run")
			elif velocity.y > 0:
				anim.play("fall")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0 and is_on_floor():
				anim.play("idle")
			elif velocity.y > 0:
				anim.play("fall")
	
	move_and_slide()

# reset when player dies
	if game.player_hp <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		game.player_hp = 10
		game.gold = 0
