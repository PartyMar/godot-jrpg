extends Node
class_name BattleController


#variables
var _started: bool = false
var _round_count: int = 0

var _fighters_ready: Array[Fighter] = []
var _fighters_exhaunted: Array[Fighter] = []

var _player_team: Array[Fighter] = [] 
var _enemy_team: Array[Fighter] = [] 

var _player_target: Fighter


#UI
@export var _target_window: PopUpTarget
@export var _end_window: PopUpBattleEnd

#Signals
signal next
signal battle_ends
signal target_selected(target: Fighter)




func start_battle(player: Array[Fighter], enemy: Array[Fighter]):
	if _started: return
	_started = true
	
	_player_team = player
	_enemy_team = enemy
	
	_fighters_ready = player + enemy
	
	#connect knocked out
	for f in _fighters_ready:
		f.knocked.connect(_knocked_out)
	
	next.connect(next_turn)
	target_selected.connect(_player_select)
	#start first round
	new_round()


func new_round():
	if !_started: return
	
	_round_count+=1
	print("\n\nROUND: "+str(_round_count))
	initiative_roll()
	next.emit()
	
func next_turn():
	if !_started: return
	
	if _fighters_ready.is_empty():
		_fighters_ready = _fighters_exhaunted
		_fighters_exhaunted = []
		new_round()
		return;
	
	var f: Fighter = _fighters_ready.pop_at(0)
	_fighters_exhaunted.append(f)
	
	if f.team == "enemy":
		_enemy_turn(f)
	elif f.team == "player":
		_player_turn(f)


#PlayerTeamMethods
func _player_turn(f: Fighter):
	
	print("\nPlayer Team turn!")
	
	_target_window.show_targets(_enemy_team, target_selected)
	await target_selected
	
	print(f.name+" attack "+_player_target.name+"!")
	f.attack(_player_target.get_health())
	var ended: bool = _check_for_end()
	if !ended: next.emit()

func _player_select(f: Fighter):
	_player_target = f

#EnemyTeamMethods
func _enemy_turn(f: Fighter):
	var target = _player_team.pick_random()
	
	print("\nEnemy Team turn!")
	print(f.name+" attack "+target.name+"!")
	f.attack(target.get_health())
	
	var ended: bool = _check_for_end()
	if !ended: next.emit()


#KnockedOutMethods
func _knocked_out(f: Fighter):
	if(f.team == "enemy"):
		_enemy_team.erase(f)
	elif(f.team == "player"):
		_player_team.erase(f)
	_fighters_ready.erase(f)
	_fighters_exhaunted.erase(f)


func _check_for_end():
	var player_lose: bool = _player_team.is_empty()
	var enemy_lose: bool = _enemy_team.is_empty()
	var message: String = "\nDraw"
	if player_lose && enemy_lose:
		message = "\nDraw, nobody win"
	elif enemy_lose:
		message = "\nPlayer win"
	elif player_lose:
		message = "\nPlayer lose"
	
	if player_lose || enemy_lose:
		_started = false
		print(message)
		_end_window.show_result(message)
		battle_ends.emit()
		return true
	return false



#Initiative
func initiative_roll():
	for f in _fighters_ready:
		var rng = randi_range(-3, 3)
		f.get_initiative().reset()
		f.get_initiative().add_number(rng)
	_sort_initiative()
	
func _sort_initiative():
	#sorting
	_fighters_ready.sort_custom(_sort_ascending)
	#Coinflip equals
	for i in range(0, _fighters_ready.size()-1, +1):
		var f1 = _fighters_ready[i]
		var f2 = _fighters_ready[i+1]
		
		if f1.get_initiative().get_value() == f2.get_initiative().get_value():
			var coinflip: bool = randi() % 2 == 0
			if coinflip:
				_fighters_ready[i] = f2
				_fighters_ready[i+1] = f1
				
	#Print order
	print("\nINITIATIVE ORDER:")
	for i in range(0, _fighters_ready.size(), +1):
		print(_fighters_ready[i].name+ " "+str(_fighters_ready[i].get_initiative().get_value()))
	
func _sort_ascending(a, b):
	if a.get_initiative().get_value() > b.get_initiative().get_value():
		return true
	return false
