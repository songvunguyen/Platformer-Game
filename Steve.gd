extends KinematicBody2D

enum States {AIR = 1, FLOOR, LADDER, WALL}  #define different states of the character 
var state = States.AIR
# const AIR = 1
# const FLOOR = 2
# const LADDER = 3
# const WALL = 4

var velocity = Vector2(0,0)
const SPEED = 180
const RUNSPEED = 400
const GRAVITY = 35
const JUMPFORCE = -1100

func _physics_process(delta):

    match state:
        States.AIR:
            if is_on_floor():
                state = States.FLOOR
                continue
            $Sprite.play("air")
            if Input.is_action_pressed('right'):
                velocity.x = lerp(velocity.x,SPEED,0.1) if velocity.x < SPEED else lerp(velocity.x,SPEED,0.03)
                $Sprite.flip_h = false
            elif Input.is_action_pressed('left'):
                velocity.x = lerp(velocity.x,-SPEED,0.1) if velocity.x > -SPEED else lerp(velocity.x,-SPEED,0.03)
                $Sprite.flip_h = true
            else:
                velocity.x = lerp(velocity.x, 0, 0.2)  #slow falldown rate
            move_and_fall()
        
        States.FLOOR:
            if not is_on_floor():
                state = States.AIR
            if Input.is_action_pressed('right'):
                if Input.is_action_pressed("run"):
                    velocity.x = lerp(velocity.x,RUNSPEED,0.1)  #increment/decrement 10% every frame until reach runspeed
                    $Sprite.set_speed_scale(1.8)
                else:
                    velocity.x = lerp(velocity.x,SPEED,0.1)
                    $Sprite.set_speed_scale(1.0)
                $Sprite.play("walk")
                $Sprite.flip_h = false
            elif Input.is_action_pressed('left'):
                if Input.is_action_pressed("run"):
                    velocity.x = lerp(velocity.x,-RUNSPEED,0.1)  #increment/decrement 10% every frame until reach runspeed
                    $Sprite.set_speed_scale(1.8)
                else:
                    velocity.x = lerp(velocity.x,-SPEED,0.1)
                    $Sprite.set_speed_scale(1.0)
                $Sprite.play("walk")
                $Sprite.flip_h = true
            else:
                $Sprite.play("idle")
                velocity.x = lerp(velocity.x, 0, 0.2)  #slow walking rate to a stop
            
            if Input.is_action_just_pressed("jump"):
                velocity.y = JUMPFORCE
                $SoundJump.play()
                state = States.AIR
            move_and_fall()
    



func move_and_fall():
    velocity.y += GRAVITY     #simulate gravity acceleration
    velocity = move_and_slide(velocity, Vector2.UP) #define the direction of the floor

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
