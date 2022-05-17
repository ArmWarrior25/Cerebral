extends CanvasLayer

var whether
var score = 0
var highscore = 0
var line = 0;
var array1: Array = []
var array2: Array = []
var accuracy
var count = 0
signal start_game
signal quit_game
signal start_trivia

func _ready():
	$Label.set_text(str($Timer.get_time_left()))
	# sets up the timer label as soon as the game starts/is called

func _process(_delta):
	$Label.set_text(str($Timer.get_time_left()).pad_decimals(0))
	# always updating the time label with the correct time left

	if score>highscore:
		highscore = score
	# always checking if a new high score was achieved

func show_message(text, wait):
	$MessageLabel.set_position(Vector2(30, 210))
	$ScoreLabel.set_position(Vector2(0, 120))
	$Label3.hide()
	$Label.show()
	$Label2.show()
	$Quit.show()
	$MessageLabel.text = text
	$MessageTimer.wait_time = wait
	$MessageLabel.show()
	$MessageTimer.start()
	# function for displaying the text with the time variable

func show_game_over():
	show_message(array1[1], 10)
	$MessageLabel.text = "Game Over"
	$MessageLabel.show()
	$StartButton.show()

func update_score(x):
	$ScoreLabel.text = str(x)
	# updates score with new text

func _on_StartButton_pressed():
	# upon start button pressed, a new file is opened and separated into question and answers for the trivia
	$StartButton.hide()
	$Menu.hide()
	var index = 0
	var fil = file()
	var file = File.new()
	file.open(fil, File.READ)

	while index < 150:
		var x = file.get_line()

		if fmod(index, 2) == 0:
			array1.append(x)

		else:
			array2.append(x)

		index+=1
	file.close()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func checkanswer(text):
	if text == array2[line]:
		# checks if the user response is the same as the answer to see if correct
		$MessageLabel.text = "Correct"
		var font = $MessageLabel.get("custom_fonts/font")
		font.size = 59
		$MessageLabel.show()
		score+=1
		update_score(score)
		
	else:
		$MessageLabel.text = "Wrong"
		var font = $MessageLabel.get("custom_fonts/font")
		font.size = 59
		$MessageLabel.show()

	line+=1
	count+=1
	yield(get_tree().create_timer(1.0), "timeout")
	$Timer.wait_time = 200.0
	$LineEdit.clear()
	new_question()

func new_question():
	# constructs a new question with new q&a
	var font = $MessageLabel.get("custom_fonts/font")
	font.size = 27
	show_message(str(array1[line]), 200.0)
	$LineEdit.show()
	$Timer.start()

	if $Timer.wait_time == 0.0:
		checkanswer($LineEdit.text)

func _on_LineEdit_text_entered(_new_text):
	$Timer.stop()
	$Timer.wait_time = 200.0
	checkanswer($LineEdit.text)

func _on_Quit_pressed():
	# closes and hides function when game is over (quit)
	array1.clear()
	array2.clear()
	$LineEdit.clear()
	$MessageLabel.set_position(Vector2(30, 43))
	$ScoreLabel.set_position(Vector2(0, 293))
	$Label3.show()
	$Label.hide()
	$Label2.hide()
	$Quit.hide()
	$Menu.show()
	$ScoreLabel.text = str(highscore)
	$Timer.stop()
	$Timer.wait_time=200.0
	$LineEdit.hide()
	$StartButton.show()
	$MessageLabel.text = "Classic\nTrivia"
	var font = $MessageLabel.get("custom_fonts/font")
	font.size = 59
	
	"""
	var rng = RandomNumberGenerator.new()
	# Trivia calculations:
	if count > 0:
		accuracy = (score / count)
		# calculates accuracy of study session
		# calculate XP:
		#(probably need some XP label in one of the corners)
		$Trivia/TriviaMain.xp += (count * 150 + rng.randi_range(1,99))
		# calculate currency
		# need label too lol in the corner or smth
		$Trivia/TriviaMain.currency += (accuracy * 100 + rng.randi_range(1,10))
	var main = load("res://scripts/TriviaMain.gd")
	$main_node.calculate(score, count)
	"""

func _on_Menu_pressed():
	# quits game
	emit_signal("quit_game")

func _on_CanvasLayer_start():
	# starts game
	emit_signal("start_trivia")

func _on_CanvasLayer_alg():
	# sets trivia topic for algebra
	whether = 1

func _on_CanvasLayer_ari():
	# sets trivia topic for arithmetic
	whether = 2

func _on_CanvasLayer_calc():
	# sets trivia topic for calculus
	whether = 3

func _on_CanvasLayer_prob():
	# sets trivia topic for probability
	whether = 4

func file():
	# sets the file for trivia up
	var rng = RandomNumberGenerator.new()
	var file
	rng.randomize()
	
	
	# enters the defined trivia topic and chooses set randomly from said topic
	if whether == 1:
		var rand = rng.randi_range(0, 7)
		if rand == 0:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/algebra__linear_1d_composed.txt"
		if rand == 1:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/algebra__linear_1d.txt"
		if rand == 2:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/algebra__linear_2d_composed.txt"
		if rand == 3:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/algebra__linear_2d.txt"
		if rand == 4:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/algebra__polynomial_roots_composed.txt"
		if rand == 5:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/algebra__polynomial_roots.txt"
		if rand == 6:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/algebra__sequence_next_term.txt"
		if rand == 7:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/algebra__sequence_nth_term.txt"

	if whether == 2:
		var rand2 = rng.randi_range(0, 8)
		if rand2 == 0:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/arithmetic__add_or_sub_in_base.txt"
		if rand2 == 1:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/arithmetic__add_or_sub.txt"
		if rand2 == 2:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/arithmetic__add_sub_multiple.txt"
		if rand2 == 3:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/arithmetic__div.txt"
		if rand2 == 4:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/arithmetic__mixed.txt"
		if rand2 == 5:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/arithmetic__mul_div_multiple.txt"
		if rand2 == 6:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/arithmetic__mul.txt"
		if rand2 == 7:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/arithmetic__nearest_integer_root.txt"
		if rand2 == 8:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/arithmetic__simplify_surd.txt"

	if whether == 3:
		var rand3 = rng.randi_range(0, 1)
		if rand3 == 0:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/calculus__differentiate_composed.txt"
		if rand3 == 1:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/calculus__differentiate.txt"

	if whether == 4:
		var rand4 =  rng.randi_range(0, 1)
		if rand4 == 0:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/probability__swr_p_level_set.txt"
		if rand4 == 1:
			file = "res://assets//mathematics_dataset-v1.0/train-medium/probability__swr_p_sequence.txt"

	return file 
