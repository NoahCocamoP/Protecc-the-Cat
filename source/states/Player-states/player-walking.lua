Player_walking = Class{__includes = BaseState}

function Player_walking:enter(player)
    self.player = player
    -- self.player.orientation determines what direction we draw our character sprite facing.
    self.animation = Animation({
        frames = {6, 7, 8, 9},
        interval = 0.2
    })
    self.player.dy = 0

    self.player.weapon.downSpike = false
end


function Player_walking:update(dt)
    if not self.player:onTile(self.player.tilemap) then
        self.player:change("falling", self.player)
    end
    self.animation:update(dt)
    if not (love.keyboard.isDown('left') or love.keyboard.isDown('a')) and not (love.keyboard.isDown('right') or love.keyboard.isDown('d')) then
        self.player.states:change("idle", self.player)
    elseif love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self.player.dx = -self.player.speed
        self.player.direction = 'left'
    else
        self.player.dx = self.player.speed
        self.player.direction = 'right'
    end
    if love.keyboard.wasPressed('space') then
        Sounds['jump']:play()
        self.player:change("jump", self.player)
    end
end

function Player_walking:render()
    love.graphics.draw(gTextures[self.player.texture], gQuads[self.player.texture][self.animation:getFrame() + (self.player.character * 9)], self.player.x, self.player.y, 0, self.player.orientation, 1, 8)
end

