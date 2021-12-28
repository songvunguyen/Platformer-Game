extends Area2D

signal coin_collected  #custom signal

func _on_coin_body_entered(body:Node):
	$AnimationPlayer.play("bounce")
	emit_signal("coin_collected")
	set_collision_mask_bit(0, false)  #turn off collision mask after coin collected to avoid double collecting
	$SoundCoinCollected.play()



func _on_AnimationPlayer_animation_finished(anim_name:String):
	queue_free()
