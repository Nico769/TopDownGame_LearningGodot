extends Node
# This script create a TileSet resource by taking
# the terrainTiles_retina.png assigned to the Sprite's
# texture.
# We take the texture width and height,
# and split it into 128x128 px chunks.
# Finally, we save the TileSet to disk.
# Note that each Tile needs a unique id.


var tile_size = Vector2(128, 128)
onready var texture = $Sprite.texture


func _ready():
    var tex_width = texture.get_width() / tile_size.x
    var tex_height = texture.get_height() / tile_size.y
    var ts = TileSet.new()
    for x in range(tex_width):
        for y in range(tex_height):
            var region = Rect2(x * tile_size.x, y * tile_size.y,
                               tile_size.x, tile_size.y)
            # Simple way to pick a unique id for each Tile
            var id = x + y * 10
            ts.create_tile(id)
            ts.tile_set_texture(id, texture)
            ts.tile_set_region(id, region)
    ResourceSaver.save("res://terrain/terrain_tiles.tres", ts)
