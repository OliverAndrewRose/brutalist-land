extends WeaponBase


onready var raycast: RayCast = get_node("../../../Interact") as RayCast;
onready var lockpick_timer: Timer = Timer.new();
export(float) var lockpick_delay: float = 10.0;
export(float) var volume_db: float = -5;

onready var lockpick_audio_player: AudioStreamPlayer = AudioStreamPlayer.new();
export(AudioStream) var lockpicking_sound;
export(AudioStream) var unlocked_sound;

var is_lockpicking: bool = false;
var current_door: DoorOpenCloser = null;

func _ready():
	add_child(lockpick_timer);
	add_child(lockpick_audio_player);
	lockpick_timer.connect("timeout",self, "finish_lockpicking");
	lockpick_audio_player.volume_db = volume_db;

# cast using the interaction raycast for a door.
func fire_weapon() -> void:
	current_door = get_door();
	
	if current_door != null:
		start_lockpicking();


# Checks for a locked door from the raycast.
func get_door() -> DoorOpenCloser:
	var col = raycast.get_collider();
	if col != null and col.has_method("toggle_door_state"):
		if col.locked:
			return col as DoorOpenCloser;
	return null;

# Start attempting to lockpick the door.
func start_lockpicking():
	is_lockpicking = true;
	lockpick_timer.start(lockpick_delay);
	
	# Start lockpicking sound loop.
	lockpick_audio_player.stream = lockpicking_sound;
	lockpick_audio_player.play();
	will_alert = true;
	pass

# Finally unlock the door.
func finish_lockpicking():
	current_door.locked = false;
	lockpick_timer.stop();
	
	# play unlocked sound.
	lockpick_audio_player.stream = unlocked_sound;
	lockpick_audio_player.play();

# Check to see if the player has stopped lockpicking.
func _process(delta):
	if is_lockpicking:
		_check_button_release();
		_check_out_of_view();

# Check to see if the player has release their action button.
func _check_button_release():
	if Input.is_action_just_released("fire"):
		stop_lockpicking();

# Check to see if the door is still in the player's view.
func _check_out_of_view():
	if raycast.get_collider() != current_door:
		stop_lockpicking();

# Interrupt the lockpicking and cancel.
func stop_lockpicking():
	lockpick_timer.stop();
	lockpick_audio_player.stop();
	is_lockpicking = false;
	current_door = null;
	will_alert = false;
