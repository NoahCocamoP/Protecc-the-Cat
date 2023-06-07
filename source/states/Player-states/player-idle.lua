Player_idle = Class{__includes = BaseState}

function Player_idle:enter(player)
    self.player = player
    self.animation = Animation({
        frames = {2, 3, 4, 5},
        interval = 0.2
    })
    self.player.dy = 0
    self.player.dx = 0
end

function Player_idle:update(dt)
    if not self.player:onTile(self.player.tilemap) then
        self.player:change("falling", self.player)
    end
    self.animation:update(dt)
    if (love.keyboard.isDown('left') or love.keyboard.isDown("a")) or (love.keyboard.isDown('right') or love.keyboard.isDown('d')) then
        self.player.states:change("walking", self.player)
    elseif love.keyboard.wasPressed('space') then
        Sounds['jump']:play()
        self.player:change('jump', self.player)
    end
end

function Player_idle:render()
    love.graphics.draw(gTextures[self.player.texture], gQuads[self.player.texture][self.animation:getFrame() + (self.player.character * 9)], self.player.x, self.player.y, 0, self.player.orientation , 1, 8)
end
