extends Node

# Each faction has a relation index for each and all the other factions.
# An index above 0 means friendly / neutral.
# An index below 0 means hostile.
# an index above 1 and below -1 will mean that the faction is permanently set to
# like / hate the player. This is useful if you don't want a faction to change their
# opinion of you based on your actions.


# List of factions within the map.
export(Array,String) var factions: Array = ["Hunter", "Guard", "Civilian"];
# A parallel 2D array which give the relation index between different factions.
export(Array,Array, int) var relations: Array = [[1,1,1],[1,1,1],[1,1,1]];


func set_faction_relation(faction_01: String, faction_02: String, relation: int) -> void:
	var _faction_01_index = factions.find(faction_01,0);
	var _faction_02_index = factions.find(faction_02, 0);
	
	if abs(relations[_faction_01_index][_faction_02_index]) > 1:
		print("The faction relation is permanently set. Use 'force_faction_relation' if required.")
		return
		
	relations[_faction_01_index][_faction_02_index] = relation;
	pass


func get_faction_relation(faction_01: String, faction_02: String) -> int:
	var _faction_01_index = factions.find(faction_01,0);
	var _faction_02_index = factions.find(faction_02, 0);
			
	return relations[_faction_01_index][_faction_02_index];
	pass
	
	
# Set the faction relation disregarding permanent relation status.
func force_faction_relation(faction_01: String, faction_02: String, relation: int) -> void:
	var _faction_01_index = factions.find(faction_01,0);
	var _faction_02_index = factions.find(faction_02, 0);
	
	relations[_faction_01_index][_faction_02_index] = relation;
	pass

func get_faction_id(faction_name: String) -> int:
	return factions.find(faction_name);


func get_faction_name(faction_id: int) -> String:
	return factions[faction_id];
