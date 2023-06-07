Tile = Class{}

function Tile:init(params)
    self.type = params.type
    self.texture = params.texture


    self.height = TILE_HEIGHT
    self.width = TILE_WIDTH

    self.isTop = params.isTop
    -- to keep the tiles visually in the same spot, but to change self.x for collision detection to seem more accurate to how it should be
    self.visualx = params.tileX
    self.visualy = params.tileY

    self.x = self.visualx + 10

    self.y = self.visualy + 2

    self.isSolid = params.isSolid

end

function Tile:render()
    love.graphics.draw(gTextures[self.texture], gQuads[self.texture][self.type], self.visualx, self.visualy)
end