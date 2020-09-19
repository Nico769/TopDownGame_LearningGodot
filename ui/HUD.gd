extends CanvasLayer

var bar_red := preload("res://assets/UI/barHorizontal_red_mid 200.png")
var bar_green := preload("res://assets/UI/barHorizontal_green_mid 200.png")
var bar_yellow := preload("res://assets/UI/barHorizontal_yellow_mid 200.png")
var bar_texture


func update_healthbar(new_value: int):
    bar_texture = bar_green
    if new_value < 60:
        bar_texture = bar_yellow
    if new_value < 25:
        bar_texture = bar_red
    var hb: TextureProgress = $"Margin/Container/HealthBar"
    hb.texture_progress = bar_texture
    # Let the health bar transition smoothly by using a Tween
    var tween: Tween = hb.get_node("Tween")
    # When using Tween.TRANS_LINEAR the last input param is ignored
    tween.interpolate_property(hb, "value", hb.value, new_value,
                               0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    # When the Tween is done, the TextureProgress's value property
    # is set to the new_value we passed in to this function
    tween.start()
    # Play the flashing healthbar animation
    $AnimationPlayer.play("healthbar_flash")


func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name == "healthbar_flash":
        $Margin/Container/HealthBar.texture_progress = bar_texture
