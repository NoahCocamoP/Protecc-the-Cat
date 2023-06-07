Cat = Class()

function Cat:init(player)
    self.player = player

    self.texture = Cats[math.random(1, #Cats)]

    self.x = self.player.x - 2

    self.y = self.player.y + 4
end

function Cat:update(dt)
    self.x = self.player.x - (2 * self.player.orientation)
    if self.player.character < 2 then
        self.y = self.player.y + 4
    else
        self.y = self.player.y
    end

    self.rotation = self.player.orientation == 1 and -0.5 or 0.5
end

function Cat:render()
    love.graphics.draw(gTextures[self.texture], self.x, self.y, self.rotation, -0.6 * self.player.orientation, 0.6, 4)
end