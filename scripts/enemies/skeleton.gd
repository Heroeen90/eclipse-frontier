extends Enemy

class_name Skeleton

func _ready():
	enemy_type = EnemyType.SKELETON
	enemy_name = "Skeleton"
	max_health = 30.0
	current_health = max_health
	attack_damage = 5.0
	speed = 100.0
	detection_range = 200.0
	attack_range = 40.0
	experience_reward = 50
	
	super._ready()