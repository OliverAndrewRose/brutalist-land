extends Node

export(float) var damage_multiplier: float = 1.0;
export(NodePath) var health_node: NodePath = NodePath("../../../../../Health");

onready var health: Health = get_node(health_node) as Health;

func process_damage(damage: float, force: Vector3):
	health.take_damage_and_force(damage * damage_multiplier, "Armature/Skeleton/" + self.name, force);
