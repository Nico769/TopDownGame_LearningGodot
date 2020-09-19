extends KinematicBody2D

const INFINITE_AMMO = -1

# Signals to handle UI updates.
signal health_changed
signal dead
signal ammo_changed

signal shoot

# To attach different types of bullets to the tank.
export (PackedScene) var Bullet
# Maximum movement speed of the tank.
export (int) var max_speed
# How fast the tank rotates.
export (float) var rotation_speed
# The time to reload of the tank's gun.
export (float) var gun_cooldown
# Tank's maximum health.
export (int) var max_health
# Available shots to fire. Default to 1.
export (int) var gun_shots = 1
# The angle between shots, having min value of 0
# and a max value of 1.5. Default to 0.2.
export (float, 0, 1.5) var gun_spread = 0.2
# Tank's maximum ammo available
export (int) var max_ammo = 20
# Current available tank's ammo.
export (int) var ammo = INFINITE_AMMO setget set_ammo

var velocity := Vector2()
var can_shoot := true
# Flag to check if tank is alive or not.
var alive := true
# Tank's health.
var health

func _ready():
    # Initialize the current health.
    health = max_health
    # Let the UI know the health is changed.
    emit_signal("health_changed", health * 100/max_health)
    emit_signal("ammo_changed", ammo * 100/max_ammo)
    # The $ symbol gets a reference to GunTimer,
    # because GunTimer is a child of the Tank node.
    $GunTimer.wait_time = gun_cooldown


func shoot(shots_num: int,
           spread: float,
           target=null):
    if can_shoot and self.ammo != 0:
        self.ammo -= 1
        can_shoot = false
        $AnimationPlayer.play("muzzle_flash")
        $GunTimer.start()
        var dir = Vector2(1, 0).rotated($Turret.global_rotation)
        if shots_num > 1:
            # Cycle through the shots to fire to assign a different angle "alpha",
            # to each of them.
            for i in range(shots_num):
                var alpha = (-spread + i) * (2 * spread) / (shots_num - 1)
                emit_signal("shoot",
                            Bullet,
                            $Turret/Muzzle.global_position,
                            dir.rotated(alpha),
                            target)
        else:
            emit_signal("shoot",
                        Bullet,
                        $Turret/Muzzle.global_position,
                        dir,
                        target)


func control(delta: float):
    # We'll call it every frame to input the controls to the tank.
    pass


func _physics_process(delta):
    if not alive:
        return
    control(delta)
    move_and_slide(velocity)


func take_damage(amount: int):
    health -= amount
    emit_signal("health_changed", health * 100/max_health)
    if health <= 0:
        explode()


func heal(amount: int):
    # The amount to heal is set in the Pickup scene.
    health += amount
    health = clamp(health, 0, max_health)
    emit_signal("health_changed", health * 100/max_health)


func explode():
    # Don't want additional bullets hitting the tank
    # while the Explosion is playing
    # For more info on set_deferred read
    # https://www.reddit.com/r/godot/comments/ex77ls/disabling_collision_shapes_in_godot_32_need_to/
    #
    # https://godotengine.org/qa/57186/disable-collisionshape2d-$collisionshape2d-disabled-godot 
    $CollisionShape2D.set_deferred("disabled", true)
    emit_signal("dead")
    # Prevent _physics_process from running
    alive = false
    # Hide the tank-related stuff
    $Turret.hide()
    $Body.hide()
    # Run the Explosion's fire animation.
    $Explosion.show()
    $Explosion.play("fire")


func _on_GunTimer_timeout():
    can_shoot = true


func _on_Explosion_animation_finished():
    # Free the tank instance from memory
    # since the animation is done.
    queue_free()


func set_ammo(value: int):
    if value > max_ammo:
        value = max_ammo
    ammo = value
    emit_signal("ammo_changed", ammo * 100/max_ammo)
