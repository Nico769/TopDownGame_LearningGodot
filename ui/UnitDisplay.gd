extends Node2D

var bar_red := preload("res://assets/UI/barHorizontal_red_mid 200.png")
var bar_green := preload("res://assets/UI/barHorizontal_green_mid 200.png")
var bar_yellow := preload("res://assets/UI/barHorizontal_yellow_mid 200.png")


func _ready():
    # Hide the healthbar if it is full
    for node in get_children():
        node.hide()

func _process(delta):
    # Don't follow the parent rotation
    global_rotation = 0


func update_healthbar(new_value: int):
    $HealthBar.texture_progress = bar_green
    if new_value < 60:
        $HealthBar.texture_progress = bar_yellow
    if new_value < 25:
        $HealthBar.texture_progress = bar_red
    if new_value < 100:
        $HealthBar.show()
    $HealthBar.value = new_value
