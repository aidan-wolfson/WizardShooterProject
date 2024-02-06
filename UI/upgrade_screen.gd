extends Control

@onready var waveMachine = get_tree().get_root().get_node("PlayerTesting/WaveMachine")
var choiceContainer 

var positiveEffects : Dictionary = {
	1: "Positive Effect Description 1",
	2: "Positive Effect Description 2",
	3: "Positive Effect Description 3",
}

var negativeEffects : Dictionary = {
	1: "Negative Effect Description 1",
	2: "Negative Effect Description 2",
	3: "Negative Effect Description 3",
}

var choices : Dictionary

func _ready():
	choiceContainer = get_node("PanelContainer/VBoxContainer/HBoxContainer")
	choices = {
	"choice1" : {"posChoiceID" : 0, "negChoiceID" : 0, "node" : choiceContainer.find_child("Choice 1")},
	"choice2" : {"posChoiceID" : 0, "negChoiceID" : 0, "node" : choiceContainer.find_child("Choice 2")},
	"choice3" : {"posChoiceID" : 0, "negChoiceID" : 0, "node" : choiceContainer.find_child("Choice 3")}
	}

func startUpgrade():
	shuffle()
	get_tree().paused = true
	self.show()

func closeScreen():
	self.hide()
	get_tree().paused = false
	waveMachine.enter()
	

func pick_random_effects(dictInput):
	var keys = dictInput.keys()
	var random_keys = []
	var random_values = []

	for i in range(3):
		var key = keys[randi() % keys.size()]
		while key in random_keys:
			key = keys[randi() % keys.size()]
		random_values.append(key)

	return random_values

func shuffle():
	var positiveEffectsArray = pick_random_effects(positiveEffects)
	var negativeEffectsArray = pick_random_effects(negativeEffects)
	
	for key in choices.keys():
		choices[key]["posChoiceID"] = positiveEffectsArray.pop_front()
		choices[key]["negChoiceID"] = negativeEffectsArray.pop_front()
		choices[key]["node"].text = positiveEffects[choices[key]["posChoiceID"]] + " // " + negativeEffects[choices[key]["negChoiceID"]]


func _on_choice_1_pressed():
	processChoice("choice1")
	closeScreen()


func _on_choice_2_pressed():
	processChoice("choice2")
	closeScreen()


func _on_choice_3_pressed():
	processChoice("choice3")
	closeScreen()

func processChoice(choiceButtonName):
	#This function needs to handle both the positive and negative effect made by the player. You can reference all of the choices in the 
	#negativeEffects or posiiveEffects dictionaries. To access the specific effects chosen by the player in this function, you can get the
	# effect id using choices[choiceButtonName]["posChoiceID"] or choices[choiceButtonName]["nedChoiceID"]
	print_debug("processChoice was called with positive choice #" + str(choices[choiceButtonName]["posChoiceID"]) + " and negative choice #" + str(choices[choiceButtonName]["negChoiceID"])) 
