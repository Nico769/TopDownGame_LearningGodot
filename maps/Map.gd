extends Node2D


func _ready():
    set_camera_limits()
    # Load and set a custom crosshair for the player.
    var crosshair_res = load("res://assets/UI/crossair_black.png")
    Input.set_custom_mouse_cursor(crosshair_res,
                                  Input.CURSOR_ARROW,
                                  # Match the tip of CURSOR_ARROW
                                  # with the center of the crosshair sprite
                                  Vector2(16, 16))


func set_camera_limits():
    var map_limits = $Ground.get_used_rect()
    var map_cellsize = $Ground.cell_size
    $Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
    $Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
    $Player/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
    $Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y


func _on_Tank_shoot(bullet: PackedScene,
                    _position: Vector2,
                    _direction: Vector2,
                    _target=null):
    var b = bullet.instance()
    add_child(b)
    b.start(_position, _direction, _target)


func _on_Player_dead():
    get_tree().reload_current_scene()
