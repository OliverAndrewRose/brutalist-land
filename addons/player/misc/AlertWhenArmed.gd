extends Node

# This node will alert NPCSs when they see
# a player who is armed by setting the player's
# relation based on their current weapon.
onready var _relations: FactionRelations = get_tree().get_root().get_node("FactionRelations") as FactionRelations;
export(Array,bool) var factions_to_alert: Array = [false,true,true];

func _process_weapon_swap(weapon: WeaponBase):
	# If the weapon does not alert enemies, return.
	if not weapon.will_alert:
		set_alert_faction_relations(1);
	else:
		set_alert_faction_relations(-1);


# Set the relation of
# Factions who are set to be alerted by the player's actions.
func set_alert_faction_relations(set_relation: int):
	
	for _index in range(0,_relations.factions.size()):
		if factions_to_alert[_index] == true:
			_relations.set_faction_relation(_relations.factions[_index], owner.faction_name, set_relation);
