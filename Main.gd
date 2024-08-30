extends Node

@export_group("Participant instances")
@export var fighters: Array[Fighter] = []

@export_group("Team sizes")
@export_range(1, 100) var playerSize = 4
@export_range(1, 100) var enemySize = 4

@export_group("Controllers")
@export var battleController: BattleController

func _ready():
	
	var playerSideText: String = "Player Team: "
	var enemySideText: String = "Enemy Team: "
	
	var playerTeam:Array[Fighter] = []
	var enemyTeam: Array[Fighter] = []
	
	
	#set fighters to playerSide
	for n in playerSize:
		var rng: int = randi_range(0, fighters.size()-1)
		var fighter: Fighter = fighters.pop_at(rng)
		
		fighter.name += " (P)"
		fighter.team = "player"
		
		playerTeam.append(fighter)
		playerSideText += fighter.name
		if(n != playerSize-1):
			playerSideText += ", "
	

	#set fighters to enemySide
	for n in enemySize:
		var rng: int = randi_range(0, fighters.size()-1)
		var fighter: Fighter = fighters.pop_at(rng)
		
		fighter.team = "enemy"
		fighter.name += " (E)"
		
		enemyTeam.append(fighter)
		enemySideText += fighter.name
		if(n != enemySize-1):
			enemySideText += ", "
	
	print(playerSideText)
	print("     VS")
	print(enemySideText)
	
	battleController.start_battle(playerTeam, enemyTeam)


