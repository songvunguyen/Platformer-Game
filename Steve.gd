extends KinematicBody2D

var velocity = Vector2(0,0)
const SPEED = 180
const GRAVITY = 35
const JUMPFORCE = -1100

func _physics_process(delta):
    if Input.is_action_pressed('right'):
        velocity.x = SPEED
        $Sprite.play("walk")
        $Sprite.flip_h = false
    elif Input.is_action_pressed('left'):
        velocity.x = -SPEED
        $Sprite.play("walk")
        $Sprite.flip_h = true
    else:
        $Sprite.play("idle")

    if not is_on_floor():
        $Sprite.play("air")
    
    velocity.y += GRAVITY     #simulate gravity acceleration

    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = JUMPFORCE
        $SoundJump.play()
    
    
    velocity = move_and_slide(velocity, Vector2.UP) #define the direction of the floor

    velocity.x = lerp(velocity.x, 0, 0.2)





func _on_Fallzone_body_entered(body:Node):
	get_tree().change_scene("res://GameOver.tscn")

func bounce():
    velocity.y = JUMPFORCE * 0.7

func ouch(var enemyposx):
    set_modulate(Color(1, 0.3, 0.3, 0.3))
    velocity.y = JUMPFORCE * 0.5

    if position.x < enemyposx:
        velocity.x = -800
    elif position.x > enemyposx:
        velocity.x = 800
    
    Input.action_release("left")
    Input.action_release("right")

    $Timer.start()




func _on_Timer_timeout():
	get_tree().change_scene("res://GameOver.tscn")