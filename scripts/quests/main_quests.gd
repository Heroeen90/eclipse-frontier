extends Node

class_name MainQuests

static func create_main_quests() -> Array[Quest]:
	var quests = []
	
	# Quest 1: Getting Started
	var quest1 = Quest.new("quest_001", "Getting Started", Quest.QuestType.MAIN)
	quest1.quest_description = "Collect 10 pieces of wood to begin your base"
	quest1.quest_giver = "Tutorial Guide"
	quest1.add_objective("Collect 10 wood", "collect_resource")
	quest1.objectives[0]["target"] = 10
	quest1.rewards = {
		"experience": 100,
		"resources": {
			"wood": 5,
			"stone": 3
		}
	}
	quests.append(quest1)
	
	# Quest 2: Building Your First Home
	var quest2 = Quest.new("quest_002", "Build Your First Home", Quest.QuestType.MAIN)
	quest2.quest_description = "Build a house to establish your base"
	quest2.quest_giver = "Tutorial Guide"
	quest2.add_objective("Build a house", "build")
	quest2.requirements = {
		"wood": 20,
		"stone": 10
	}
	quest2.rewards = {
		"experience": 150,
		"resources": {
			"food": 20
		}
	}
	quests.append(quest2)
	
	# Quest 3: Storage Solutions
	var quest3 = Quest.new("quest_003", "Storage Solutions", Quest.QuestType.MAIN)
	quest3.quest_description = "Build a storage unit to expand your carrying capacity"
	quest3.quest_giver = "Merchant"
	quest3.add_objective("Build a storage", "build")
	quest3.requirements = {
		"wood": 30,
		"stone": 20,
		"iron": 5
	}
	quest3.rewards = {
		"experience": 200,
		"resources": {
			"stone": 15
		}
	}
	quests.append(quest3)
	
	# Quest 4: Mining Operations
	var quest4 = Quest.new("quest_004", "Mining Operations", Quest.QuestType.MAIN)
	quest4.quest_description = "Build a mine to extract iron ore"
	quest4.quest_giver = "Engineer"
	quest4.add_objective("Build a mine", "build")
	quest4.add_objective("Collect 20 iron", "collect_resource")
	quest4.objectives[1]["target"] = 20
	quest4.requirements = {
		"wood": 40,
		"stone": 50
	}
	quest4.rewards = {
		"experience": 300,
		"resources": {
			"iron": 10
		}
	}
	quests.append(quest4)
	
	# Quest 5: Agricultural Development
	var quest5 = Quest.new("quest_005", "Agricultural Development", Quest.QuestType.MAIN)
	quest5.quest_description = "Build a farm to produce food"
	quest5.quest_giver = "Farmer"
	quest5.add_objective("Build a farm", "build")
	quest5.add_objective("Harvest 50 food", "collect_resource")
	quest5.objectives[1]["target"] = 50
	quest5.rewards = {
		"experience": 250,
		"resources": {
			"food": 30
		}
	}
	quests.append(quest5)
	
	return quests