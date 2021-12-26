extends Node
export(bool) var deleteOnReady: bool = true;
export(float) var delay: float = 3.0;
onready var _timer = Timer.new();

func _ready():
	add_child(_timer);
	_timer.wait_time = delay;
	_timer.connect("timeout",self,"timer_timeout");
	if deleteOnReady:
		_timer.start();
	pass

func start_timer():
	_timer.start();

func timer_timeout():
	queue_free();
	pass
