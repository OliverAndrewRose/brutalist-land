extends RigidBody
class_name Bullet

var bullet_damage: int = 30;
var bullet_force: float = 300.0;
var impacted: bool = false;

func _on_Bullet_body_entered(body):
	if not impacted:
		impacted = true;
	else:
		queue_free();

func _on_delete_timer_timeout():
	queue_free();
