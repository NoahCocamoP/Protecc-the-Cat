Player_jumping = Class{__includes = BaseState}

function Player_jumping:enter(player)
    self.player = player

    self.player.dy = -150

    self.player.jumping = true
end

function Player_jumping:update(dt)
    if self.player.collisionDirection == 'none' then
        if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
            self.player.dx = math.max(math.min(self.player.dx, 0) + (-self.player.speed  * dt), -self.player.speed)
            self.player.direction = 'left'
        elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
            self.player.dx = math.min(math.max(self.player.dx, 0) + (self.player.speed * dt), self.player.speed)
            self.player.direction = 'right'
        end
    end
    self.player.dy = self.player.dy + (GRAVITY * dt)
    if self.player.dy > 0 then
        self.player.jumping = false
        self.player:change("falling", self.player)
    end
    self:downSpike()
    self:downSpikeHits()
end

function Player_jumping:render()
    love.graphics.draw(gTextures[self.player.texture], gQuads[self.player.texture][1 + (self.player.character * 9)], self.player.x, self.player.y, 0, self.player.orientation, 1, 8)
end

function Player_jumping:downSpike()
    if love.keyboard.isDown('q') then
        self.player.weapon.downSpike = true
    elseif not love.keyboard.isDown('q') then
        self.player.weapon.downSpike = false
    end
end

function Player_jumping:downSpikeHits()
    if self.player.weapon.downSpike == true then
        if self.player.weapon:downSpikeActive() then
            self.player.weapon.downSpike = false
            self.player.isFalling = false
            Sounds['jump']:play()
            self.player:change('jump', self.player)
        end
    end
end