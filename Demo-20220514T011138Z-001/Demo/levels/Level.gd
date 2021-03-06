extends Node2D

var score =0
var highscore = 0
# creates a variable for the score and highscore

onready var width: = get_viewport_rect().size.x
onready var height: = get_viewport_rect().size.y
# sets x and y dimensions for the screen

var platform: = preload("res://objects/Platform.tscn")
# calls the platform tcsn

var platformCount: = 1
onready var player: = $Player
onready var platformParent: = $Platforms
var platforms: = []
onready var treshold: = height * 0.5
var scrollSpeed = 0.05
onready var background:Sprite = $"ParallaxBackground/ParallaxLayer/Sprite"
# initializes platformCount, player, playerParent, threshold, scrollspeed, and the repeating background

func _ready()->void:
	OS.center_window()
	player.global_position.y = treshold
	for i in platformCount:
		var inst: = platform.instance()
		inst.global_position.y = 100
		platformParent.add_child(inst)
		platforms.append(inst)
	# spawns a platform at the appropriate y value
	#safety net - put lowest platform under player
	player.global_position.x = rand_x()
	# gets a random x value
	$Label3.show()
	$Label.set_text(str(highscore))
	yield(get_tree().create_timer(2), "timeout")
	$Label3.hide()
	$Label.set_position(Vector2(205, 0))
	$Label.set_text(str(score))

func rand_x()->float:
	return rand_range(28.0, width-28.0)
	# gets a random x value within the allowed range

func _physics_process(delta:float)->void:
	$Label.set_text(str(score))
	if player.global_position.y < treshold:
		# spawns the answer choice platforms after y threshold reached
		var move:float = lerp(0.0, treshold -player.global_position.y, scrollSpeed)
		move_background(move)
		player.global_position.y += move
		for plat in platforms:
			$Label2.set_text(plat.array1[plat.rand6])
			plat.global_position.y += move
			if player.is_on_floor():
				if plat.rand5 == 0:
					if player.global_position.x >0 && player.global_position.x < 60:
						score+=1
				if plat.rand5 == 1:
					if player.global_position.x >130 && player.global_position.x < 195:
						score+=1
				if plat.rand5 == 2:
					if player.global_position.x >290 && player.global_position.x < 350:
						score+=1
				if plat.rand5 == 3:
					if player.global_position.x >420 && player.global_position.x < 480:
						score+=1
			if plat.global_position.y > height-200:
				platforms.clear()
				# clear platform after a certain height
				plat.global_position.y= 730
				var inst: = platform.instance()
				inst.global_position.y = 100
				platformParent.add_child(inst)
				platforms.append(inst)
	if player.global_position.x< 0:
		player.global_position.x = 455
	if player.global_position.x> 455:
		player.global_position.x = 0
	# spawns on opposite side if jumps too far to right or left
	if player.global_position.y > height:
		game_over()
		# ends game when falls out of bounds
func process():
	if score>highscore:
		highscore = score
	# overrides highscore with score

func move_background(move:float)->void:
	var ratio: = 0.75
	background.global_position.y = fmod((background.global_position.y +height +move*ratio), height) - height
	# moves background with player


func game_over()->void:
	get_tree().reload_current_scene()
	# resets screen after player death

