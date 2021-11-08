extends RigidBody
class_name Bullet

var bullet_damage: int = 20;

func _on_Bullet_body_entered(body):
	if(body.is_in_group("damagable")):
		body.get_node("Health").take_damage(bullet_damage);
		print(body.get_node("Health"))
		

func _on_delete_timer_timeout():
	queue_free();
