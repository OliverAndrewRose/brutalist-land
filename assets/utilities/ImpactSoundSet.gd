extends Node;

export(Array, AudioStream) var GLASS;

func GetSound(material_type: String) -> AudioStream:
	var rand: RandomNumberGenerator = RandomNumberGenerator.new();
	var sounds: Array = get(material_type) as Array;
	return sounds[rand.randi_range(0,sounds.size()-1)];
