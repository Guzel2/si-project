extends AnimatedSprite

var phase = -1

#func _process(_delta):
#	match phase:
#		0: #idle
#			pass
#		1: #wind-up
#			var desired_position = Vector2(150, 450)
#			var desired_scale = Vector2(1.3, 1.3)
#			var desired_rotation = -60
#			
#			var position_modifier = 5
#			var scale_modifier = 5
#			var rotation_modifier = 5
#			
#			var next_phase = true
#			
#			
#			if !set_position_to(desired_position, position_modifier):
#				next_phase = false
#			
#			if !set_scale_to(desired_scale, scale_modifier):
#				next_phase = false
#			
#			if !set_rotation_to(desired_rotation, rotation_modifier):
#				next_phase = false
#			
#			if next_phase:
#				rotation_degrees = desired_rotation
#				scale = desired_scale
#				position = desired_position
#				phase = 2
#		
#		2: #swing
#			var desired_position = Vector2(320, 350)
#			var desired_scale = Vector2(1.6, 1.6)
#			var desired_rotation = 45
#			
#			var position_modifier = 2
#			var scale_modifier = 2
#			var rotation_modifier = 2
#			
#			var next_phase = true
#			
#			
#			if !set_position_to(desired_position, position_modifier):
#				next_phase = false
#			
#			if !set_scale_to(desired_scale, scale_modifier):
#				next_phase = false
#			
#			if !set_rotation_to(desired_rotation, rotation_modifier):
#				next_phase = false
#			
#			if next_phase:
#				rotation_degrees = desired_rotation
#				scale = desired_scale
#				position = desired_position
#				phase = 3
#		
#		3: #overshoot
#			var desired_position = Vector2(325, 370)
#			var desired_scale = Vector2(1.55, 1.55)
#			var desired_rotation = 60
#			
#			var position_modifier = 7
#			var scale_modifier = 7
#			var rotation_modifier = 7
#			
#			var next_phase = true
#			
#			
#			if !set_position_to(desired_position, position_modifier):
#				next_phase = false
#			
#			if !set_scale_to(desired_scale, scale_modifier):
#				next_phase = false
#			
#			if !set_rotation_to(desired_rotation, rotation_modifier):
#				next_phase = false
#			
#			if next_phase:
#				rotation_degrees = desired_rotation
#				scale = desired_scale
#				position = desired_position
#				phase = 4
#		
#		4:#return
#			var desired_position = Vector2(135, 600)
#			var desired_scale = Vector2(1, 1)
#			var desired_rotation = 0
#			
#			var position_modifier = 8
#			var scale_modifier = 8
#			var rotation_modifier = 8
#			
#			var next_phase = true
#			
#			
#			if !set_position_to(desired_position, position_modifier):
#				next_phase = false
#			
#			if !set_scale_to(desired_scale, scale_modifier):
#				next_phase = false
#			
#			if !set_rotation_to(desired_rotation, rotation_modifier):
#				next_phase = false
#			
#			if next_phase:
#				rotation_degrees = desired_rotation
#				scale = desired_scale
#				position = desired_position
#				phase = 0


func _process(delta):
	if phase > 0:
		frame = 0
		animation = 'hit'
		phase = 0

func set_position_to(desired_position: Vector2, modifier: int):
	position = (position * modifier + desired_position) / (modifier + 1)
	
	if (position - desired_position).length() < 5:
		return true

func set_scale_to(desired_scale: Vector2, modifier: int):
	scale = (scale * modifier + desired_scale) / (modifier + 1)
	
	if (scale - desired_scale).length() < .1:
		return true

func set_rotation_to(desired_rotation: float, modifier: int):
	rotation_degrees = (rotation_degrees * modifier + desired_rotation) / (modifier + 1)
	
	if (rotation_degrees - desired_rotation) < 2.5:
		return true

func set_modulate_to(desired_color: Color, modifier: int):
	modulate = (modulate * modifier + desired_color) / (modifier + 1)
	
	if modulate.is_equal_approx(desired_color):
		return true


func _on_character_animation_finished():
	animation = 'idle'
