tileset = {}

tileset.texture = "tileset01.png"

tiles = {}
tiles[1] = {x = 0, y = 0, solid = 0}
tiles[2] = {x = 1, y = 0, solid = 1/0}
tiles[3] = {x = 2, y = 0, solid = 1/0}
tileset.tiles = tiles

return tileset
