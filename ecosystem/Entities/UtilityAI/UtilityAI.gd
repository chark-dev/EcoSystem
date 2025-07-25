extends Node
class_name UtilityAI

var actor 

func init(c):
	actor = c

func get_candidate_tiles_for_goal(goal: String, data: Dictionary) -> Array[Vector2i]:
	print("goal: ", goal)
	var tiles : Array[Vector2i] = []
	
	match goal:
		"attack":
			tiles = data.get("predator_tiles", [])
		"retreat":
			tiles = data.get("safe_tiles", [])
		"group":
			tiles = data.get("ally_tiles", [])
		"heal":
			tiles = data.get("safe_tiles", [])
		"move":
			tiles = data.get("reachable_tiles", [])

	return tiles

func select_best_goal(goals: Dictionary) -> String:
	var best_goal = ""
	var highest_score = -INF
	for goal in goals.keys():
		if goals[goal] > highest_score:
			highest_score = goals[goal]
			best_goal = goal
	return best_goal

func run_heuristics(data: Dictionary) -> Dictionary:
	var heuristics = {}
	
	heuristics["in_range"] = distance_heuristic(data)
	heuristics["courage"] = courage_heuristic(data)
	heuristics["health"] = health_heuristic()
	heuristics["attack"] = attack_heuristic()
	print(heuristics)
	
	
	return heuristics


func health_heuristic() -> float:
	if actor.stats.health >= actor.stats.max_health / 2:
		return 0.5
	else:
		return 0

func distance_heuristic(data) -> float:
	var output : float = 0
	for target in data["predator_tiles"]:
		var path = actor.level_manager.get_actor_path(actor.global_position,
		actor.level_manager.tile_map.map_to_local(target))
		print(path)
		if path.size() <= actor.stats.movement:
			output = 1
	return output 

func courage_heuristic(data) -> float:
	if data["ally_tiles"].size() >= actor.stats.courage:
		return 0.5
	else:
		return 0
	

func attack_heuristic():
	var can_attack = 1
	return can_attack


func decide_goal(heuristics: Dictionary):
	var goals = {
	"move": 0,
	"retreat": 0,
	"attack": 0,
	"heal": 0,
	"group": 0,
	}
	
		# You can use weighted heuristics here
	goals["attack"] += heuristics["attack"] * 2
	goals["move"] += heuristics["in_range"] * 1
	goals["group"] += heuristics["courage"] * 1
	if not heuristics["health"]:
		goals["heal"] += 1
		goals["retreat"] += 1

	print("Goal scores: ", goals)
	return goals



func score_retreat_tile(tile: Vector2i) -> float:
	var dist = 0.0
	for enemy_pos in actor.level_manager.get_enemy_positions():
		dist += tile.distance_to(enemy_pos)
	return dist # Higher = better
	

func score_attack_tile(tile: Vector2i) -> float:
	return 0
	#if is_enemy_in_range(tile):
		#return 1.0
	#return 0.0

func score_group_tile(tile: Vector2i) -> float:
	var score = 0.0
	for ally_pos in actor.level_manager.get_ally_positions():
		score += 1.0 / (tile.distance_to(ally_pos) + 1)
	return score
	

func choose_best_tile(goal: String, tiles: Array[Vector2i]) -> Vector2i:
	var best_score = -INF
	var best_tile = null

	print("tiles: ", tiles)
	for tile in tiles:
		
		
		
		var score = 0.0
		match goal:
			"retreat":
				score = score_retreat_tile(tile)
			"attack":
				score = score_attack_tile(tile)
			"group":
				score = score_group_tile(tile)
			_:
				score = 0.0 # default

		if score > best_score:
			best_score = score
			best_tile = tile


	print(best_tile)
	return best_tile
