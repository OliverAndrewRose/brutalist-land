extends RigidBody
class_name Bullet

var bullet_damage: int = 30;
var bullet_force: float = 250.0;
var impacted: bool = false;

func _on_Bullet_body_entered(body):
	if not impacted:
		impacted = true;
		$bullet_sounds.queue_free();
		$delete_timer.wait_time = 0.1;
	else:
		queue_free();

func _on_delete_timer_timeout():
	queue_free();
