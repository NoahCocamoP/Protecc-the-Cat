Entity = Class{}

function Entity:init(params)
    self.texture = params.texture
    self.states = params.states
    
    self.width = params.width
    self.height = params.height

    self.x = params.x
    self.y = params.y

    self.dx = 0
    self.dy = 0

    self.direction = 'left'
end


function Entity:collides(entity)
    return not (self.x > entity.x + entity.width or entity.x > self.x + self.width or
                self.y > entity.y + entity.height or entity.y > self.y + self.height)
end


function Entity:update(dt)
    self:updateOrientation()
    self:constrainMovement()
    self:updateMovement(dt)
    self.states:update(dt)
    self.currentAnimation:update(dt)
    self:tileCollisions(self.player.tilemap)
end

function Entity:render()
    self.states:render()
end

function Entity:change(state, params)
    self.states:change(state, params)
end

function Entity:constrainMovement()
    if self.x - self.width < 3 then
        self.x = self.x + 4
    elseif self.x + self.width + 2 > self.currentBackground:getWidth() then
        self.x = self.currentBackground:getWidth() - self.width - 4
    end
end

function Entity:updateMovement(dt)
    self.x = self.x + (self.dx * dt)
    self.y = self.y + (self.dy * dt)
end

function Entity:updateOrientation()
    self.orientation = self.direction == 'left' and -1 or 1
end

function Entity:minimumDistance(entity)
    local startingPosX = self.x 
    local startingPosY = self.y
    local countUp = 0
    local countDown = 0
    local countLeft = 0
    local countRight = 0
    -- check up
    while (self:collides(entity)) do
        self.y = self.y - 1
        countUp = countUp - 1
    end
    -- check down
    self.y = startingPosY
    while (self:collides(entity)) do
        self.y = self.y + 1
        countDown = countDown + 1
    end
    -- check left
    self.y = startingPosY
    while (self:collides(entity)) do
        self.x = self.x - 1
        countLeft = countLeft - 1
    end
    self.x = startingPosX
    while (self:collides(entity)) do
        self.x = self.x + 1
        countRight = countRight + 1
    end
    self.x = startingPosX
    -- compare the positive nums
    local min1 = math.min(countDown, countRight)
    -- compare the negative nums
    local min2 = math.max(countUp, countLeft)
    -- compare the min values of the two winners
    local finalmin = math.min(min1, math.abs(min2))
    -- check to see who won, add the winner to their respective axis.
    if finalmin == -countUp then
        self.y = self.y + countUp
        return 'up'
    elseif finalmin == countDown then
        self.y = self.y + countDown
        return 'down'
    elseif finalmin == -countLeft then
        self.x = self.x + countLeft
        return 'left'
    elseif finalmin == countRight then
        self.x = self.x + countRight
        return 'right'
    end
end

function Entity:tileCollisions(tilemap)
    local direction = 'none'
    for k, tile in pairs(tilemap) do
        if self:collides(tile) and tile.isSolid then
            direction = self:minimumDistance(tile)
            return direction
        end
    end
    return direction
end

function Entity:onTile(tilemap)
    for k, tile in pairs(tilemap) do
        if tile.isSolid then
            if self:collides(tile) then
                return true
            else
                self.x = self.x + 2
                if self:collides(tile) then
                    self.x = self.x - 2
                    return true
                else
                    self.x = self.x - 4
                    if self:collides(tile) then
                        self.x = self.x + 2
                        return true
                    else
                        self.x = self.x + 2
                        self.y = self.y + 2
                        if self:collides(tile) then
                            self.y = self.y - 2
                            return true
                        else
                            self.y = self.y - 2
                        end
                    end
                end
            end
        end
    end
end

function Entity:negateMomentum()
    if self.collisionDirection == 'up' and self.dy > 0 then
        self.dy = 0
    elseif self.collisionDirection == 'left' and self.dx > 0 then
        self.dx = 0
    elseif self.collisionDirection == 'right' and self.dx < 0 then
        self.dx = 0
    elseif self.collisionDirection == 'down' and self.dy < 0 then
        self.dy = 0
    end
end

function Entity:updateDirection()
    if self.dx > 0 then
        self.direction = 'right'
    elseif self.dx < 0 then
        self.direction = 'left'
    end
end

function Entity:aboveTile()
    for k, tile in pairs(self.player.tilemap) do
        if tile.y - self.y < 30 and tile.y - self.y > 0 and tile.isSolid then
            if self:collides(tile) then
                return true
            else
                self.y = self.y + 4
                if self:collides(tile) then
                    self.y = self.y - 4
                    return true
                else
                    self.y = self.y - 4
                end
            end
        end
    end
    return false
end