extends QodotEntity
# This entity is for use within TrenchBroom. This will contain simplified methods
# which can then be set to be invoked within the TrenchBroom editor.

var faction_name = "Guards";
onready var _faction_relations: FactionRelations = get_tree().get_root().get_node("FactionRelations") as FactionRelations;

# Edit the relation index between this faction and another given faction.
func set_faction_relation(other_faction: String, relation: float) -> void:
	_faction_relations.set_faction_relation(faction_name, other_faction, relation);
	pass

# Sets the faction to be angry towards the given character's faction.
func set_anger_to_characters_faction(character: Spatial) -> void:
	var char_faction = get_entity_faction(character);
	if char_faction != -1 and char_faction != _faction_relations.get_faction_id(faction_name):
		set_faction_relation(_faction_relations.get_faction_name(char_faction), -1.0);
		pass

# Sets the faction to be neutral towards the give character's faction.
func set_neutral_to_characters_faction(character: Spatial) -> void:
	var char_faction = get_entity_faction(character);
	if char_faction != -1 and char_faction != _faction_relations.get_faction_id(faction_name):
		set_faction_relation(_faction_relations.get_faction_name(char_faction), 1.0);
		pass

# Returns -1 if the entity has no faction.
func get_entity_faction(character: Spatial) -> int:
	if "faction_index" in character:
		return character.faction_index;
	return -1;

# Updates the properties from TrenchBroom.
func update_properties() -> void:
	if "faction_name" in properties:
		faction_name = properties.faction_name;
	pass
