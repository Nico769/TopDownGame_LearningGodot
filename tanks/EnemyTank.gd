extends "res://tanks/Tank.gd"

onready var parent: PathFollow2D = get_parent()
export (float) var turret_speed
# The radius of the DetectRadius circle
export (int) var detect_radius
var speed := 0
var target = null

func _ready():
    var circle = CircleShape2D.new()
    $DetectRadius/CollisionShape2D.shape = circle
    $DetectRadius/CollisionShape2D.shape.radius = detect_radius


func control(delta: float):
    if parent is PathFollow2D:
        # Check whether something is in front of the tank..
        if $LookAhead1.is_colliding() or $LookAhead2.is_colliding():
            # ..and start decelerating
            speed = lerp(speed, 0, 0.1)
        else:
            # ..or accelerating if the way is clear
            speed = lerp(speed, max_speed, 0.05)
        parent.set_offset(parent.get_offset() + speed * delta)
        # Ensure the tank follows the path correctly
        # even when it hits an obstacle
        position = Vector2()
    else:
        # other movement code
        pass


func _process(delta):
    # If a target has been acquired..
    if target:
        # ..compute the target position w.r.t the current
        # tank position and..
        var target_dir: Vector2 = (target.global_position - global_position)
        # ..instantiate a unit vector, rotated by the current turret angle and.. 
        var current_dir = Vector2(1, 0).rotated($Turret.global_rotation)
        # ..rotate the turret
        $Turret.global_rotation = current_dir.linear_interpolate(target_dir,
                                                                 turret_speed * delta).angle()
        if target_dir.dot(current_dir) > 0.9:
            shoot(gun_shots, gun_spread, target)


func _on_DetectRadius_body_entered(body):
        target = body


func _on_DetectRadius_body_exited(body):
    # Drop the target if it leaves the area
    if body == target:
        target = null
