extends Node

class_name SideQuests

static func create_side_quests() -> Array[Quest]:
	var quests = []
	
	# Side Quest 1: Monster Hunter
	var quest1 = Quest.new("side_001", "Monster Hunter", Quest.QuestType.SIDE)
	quest1.quest_description = "Defeat 5 skeletons"
	quest1.quest_giver = "Warrior"
	quest1.add_objective("Defeat 5 skeletons", "defeat_enemy")
	quest1.objectives[0]["target"] = 5
	quest1.rewards = {
		"experience": 75,
		"resources": {
			"stone": 10
		}
	}
	quest1.is_repeatable = true
	quests.append(quest1)
	
	# Side Quest 2: Treasure Hunter
	var quest2 = Quest.new("side_002", "Treasure Hunter", Quest.QuestType.SIDE)
	quest2.quest_description = "Find 3 treasure chests"
	quest2.quest_giver = "Adventurer"
	quest2.add_objective("Find 3 treasure chests", "find_item")
	quest2.objectives[0]["target"] = 3
	quest2.rewards = {
		"experience": 100,
		"resources": {
			"iron": 5
		}
	}
	quest2.is_repeatable = true
	quests.append(quest2)
	
	# Side Quest 3: Resource Gatherer
	var quest3 = Quest.new("side_003", "Resource Gatherer", Quest.QuestType.SIDE)
	quest3.quest_description = "Collect 50 wood"
	quest3.quest_giver = "Lumberjack"
	quest3.add_objective("Collect 50 wood", "collect_resource")
	quest3.objectives[0]["target"] = 50
	quest3.rewards = {
		"experience": 50,
		"resources": {
			"food": 15
		}
	}
	quest3.is_repeatable = true
	quests.append(quest3)
	
	return quests