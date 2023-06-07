Player_falling = Class{__includes = BaseState}

function Player_falling:enter(player)
    self.player = player

    self.player.isFalling = true
end

function Player_falling:update(dt)
    self:downSpike()
    self:downSpikeHits()
    self.player.dy = self.player.dy + (GRAVITY * dt)
    self:directionHandling(self.player.collisionDirection)
    if self.player.collisionDirection == 'none' then
        if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
            self.player.dx = math.max(math.min(self.player.dx, 0) + (-self.player.speed  * dt), -self.player.speed)
            self.player.direction = 'left'
        elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
            self.player.dx = math.min(math.max(self.player.dx, 0) + (self.player.speed * dt), self.player.speed)
            self.player.direction = 'right'
        end
    end
end

function Player_falling:render()
    love.graphics.draw(gTextures[self.player.texture], gQuads[self.player.texture][4 + (self.player.character * 9)], self.player.x, self.player.y, 0, self.player.orientation, 1, 8)
end

function Player_falling:directionHandling(direction)
    if direction == 'up' then
        Sounds['hit']:play()
        self.player.isFalling = false
        self.player:change('walking', self.player)
    elseif direction == 'left' then
        self.player.dx = self.player.dx - 10
    elseif direction == 'right' then
        self.player.dx = self.player.dx + 10
    end
end

function Player_falling:downSpike()
    if love.keyboard.isDown('q') then
        self.player.weapon.downSpike = true
    elseif not love.keyboard.isDown('q') then
        self.player.weapon.downSpike = false
    end
end

function Player_falling:downSpikeHits()
    if self.player.weapon.downSpike == true then
        if self.player.weapon:downSpikeActive() then
            self.player.weapon.downSpike = false
            self.player.isFalling = false
            Sounds['jump']:play()
            self.player:change('jump', self.player)
        end
    end
end