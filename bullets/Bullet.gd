extends Area2D

export (int) var speed
export (int) var damage
export (float) var lifetime
# Seeking missile agility
export (float) var steer_force = 0
var velocity = Vector2()
var acceleration = Vector2()
var target = null

func start(_position: Vector2,
           _direction: Vector2,
           _target):
    position = _position
    rotation = _direction.angle()
    $Lifetime.wait_time = lifetime
    velocity = _direction * speed
    target = _target

# Handle the seeking behavior of the seeking missile
func seek():
    var desired = (target.position - position).normalized() * speed
    var steer = (desired - velocity).normalized() * steer_force
    return steer


func _process(delta):
    # If a seeking missile is launched then
    # target is not null.
    if target:
        acceleration += seek()
        velocity += acceleration * delta
        velocity = velocity.clamped(speed)
        rotation = velocity.angle()
    position += velocity * delta


func explode():
    # Stop the bullet
    velocity = Vector2(0, 0)
    $Sprite.hide()
    # Run the Explosion's smoke animation.
    $Explosion.show()
    $Explosion.play("smoke")


func _on_Bullet_body_entered(body):
    explode()
    if body.has_method('take_damage'):
        body.take_damage(damage)


func _on_Lifetime_timeout():
    explode()


func _on_Explosion_animation_finished():
    # Free the bullet instance from memory
    # since the animation is done.
    queue_free()
