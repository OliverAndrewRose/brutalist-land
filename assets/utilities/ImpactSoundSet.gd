extends Node;

var sounds: Dictionary;
var _file: File;
var _rand: RandomNumberGenerator = RandomNumberGenerator.new();
var _raw_file_string: String;
export var sound_impact_file = "res://assets/utilities/impact_sounds.json";

func _ready() -> void:
	_load_file();
	_load_sounds();
	_close_file();
	pass


func get_sound(material_type: String) -> AudioStream:
	
	var material_sounds: Array = sounds[material_type] as Array;
	_rand.randomize();
	return material_sounds[_rand.randi_range(0,material_sounds.size()-1)];


func _load_file() -> void:
	_file = File.new();
	_file.open(sound_impact_file, File.READ);
	_raw_file_string = _file.get_as_text().dedent();
	_raw_file_string = _raw_file_string.replace("\t", "");
	_raw_file_string = _raw_file_string.replace("\n", "");
	pass


func _close_file() -> void:
	_file.close();


func _load_sounds() -> void:
	
	var _sound_result: JSONParseResult = JSON.parse(_raw_file_string);
	var _sound_data: Dictionary = _sound_result.result as Dictionary;
	
	var _materials: Array = _sound_data["materials"];
	for _material in _materials:
		sounds[_material] = [] as Array;
		for _sound_index in range(0, _sound_data[_material].size()):
			sounds[_material].append(load(_sound_data[_material][_sound_index]));
