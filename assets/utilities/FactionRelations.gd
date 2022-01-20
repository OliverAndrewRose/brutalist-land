extends Node

# Each faction has a relation index for each and all the other factions.
# An index above 0 means friendly / neutral.
# An index below 0 means hostile.


# List of factions within the map.
export(Array,String) var factions: Array = ["Hunter", "Guards", "Civilian"];
# A parallel 2D array which give the relation index between different factions.
export(Array,Array, int) var relations: Array = [[1,1,1],[-1,1,-1],[1,1,1]];


func set_faction_relation(faction_01: String, faction_02: String, relation: int):
	var _faction_01_index = factions.find(faction_01,0);
	var _faction_02_index = factions.find(faction_02, 0);
	
	relations[_faction_01_index][_faction_02_index] = relation;
	pass
