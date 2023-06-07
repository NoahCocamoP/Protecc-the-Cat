Enemy = Class{__includes = Entity}

function Enemy:init(params)
    self.currentBackground = params.background

    self.texture = params.texture

    self.states = params.states

    self.width = params.width

    self.height = params.height

    self.player = params.player

    self.tilemap = params.tilemap

    self.x = params.x
    self.y = params.y

    self.dx = 0
    self.dy = 0

    self.direction = 'left'

    self.orientation = self.direction == 'left' and -1 or 1

    self.cooldown = false

    self.collisionDirection = 'none'

    self.health = Health(2 + self.player.level, self)

    self.iFrames = false

    self.isPowerful = params.isPowerful

    if self.isPowerful then
        self.color = SetColors[math.random(1, #SetColors)]
        self.health:reset(math.floor(self.health.total * 1.5))
    end
end

function Enemy:update(dt)
    if not self:aboveTile() then
        self:change('falling', self)
    end
    self:updateDirection()
    self:updateOrientation()
    self:constrainMovement()
    self:updateMovement(dt)
    self.states:update(dt)
    self.currentAnimation:update(dt)
    self.collisionDirection = self:tileCollisions(self.player.tilemap)
    self:negateMomentum()
    self.health:update()
    self:attacksPlayer(self.player)
end


function Enemy:render()
    self.health:render()
    if self.isPowerful then
        love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
    end
    love.graphics.draw(gTextures[self.texture], gQuads[self.texture][self.currentAnimation:getFrame()], self.x, self.y, 0, self.orientation, 1, 8)
    love.graphics.setColor(1, 1, 1, 1)
end

function Enemy:attacksPlayer(player)
    if not self.cooldown then
        if self:collides(player) then
            if not player.iFrames then
                if player.character % 2 == 1 then
                    Sounds['male-damaged']:play()
                else
                    Sounds['female-damaged']:play()
                end
                if self.powerful then
                    player.health:change(2)
                else
                    player.health:change(1)
                end
                self.cooldown = true
                player.iFrames = true
                local cd = Timer.after(1, function()
                self.cooldown = false
                player.iFrames = false end)
                end
        end
    end
end

function Enemy:wasHit(strength)
    self.health:change(strength)
    Sounds['enemy-damaged']:play()
end