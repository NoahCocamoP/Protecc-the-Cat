Weapon = Class{__includes = Entity}

function Weapon:init(params)
    -- start the weapon facing directly upwards, with normal sprite width
    self.dimensions = {
        ['width'] = 30,
        ['rotation'] = 3.25
    }

    self.texture = params.texture

    self.player = params.player

    self.height = 31

    self.width = self.dimensions['width']

    self.visualx = self.player.x + (3 * self.player.orientation)
    
    self.x  = self.player.x + (5 * self.player.orientation)
    self.y = self.player.y

    self.visualy = self.player.y + 16
    -- Self.hitting determines whether we are actively using an attack or not
    self.hitting = false
    -- Self.downSpike determines if we are actively using a downspike or not.
    self.downSpike = false
end

function Weapon:update(dt)
    
    self.visualx = self.player.x + (3 * self.player.orientation)
    if not self.downSpike then
        self.x = self.player.orientation == 1 and self.visualx or self.player.x - 30
        self.width = self.player.orientation == 1 and self.dimensions['width'] or 25
        self.y = self.player.y
    else
        self.x = self.player.x
        self.width = self.player.width
        self.y = self.player.y + 15
    end
    self.visualy = self.player.y + 16
end

function Weapon:animateSwing()
    Sounds['attack']:play()
    -- Stops the previous tween, to account for repeated press' of Q
    if Swing then
        Swing:remove()
    end
    -- Set the values to their starting positions, to account for repeated press' of Q
    self.dimensions['rotation'] = 3.25
    -- Use ['rotation'] to rotate the image, to look like the weapon is swinging downwards
    local Swing = Timer.tween(0.35, {
        [self.dimensions] = {['rotation'] = 6}
    }):finish(function() 
        self.hitting = false
        self.dimensions['rotation'] = 3.25
    end)
end

function Weapon:render()
    if self.hitting and not self.downSpike then
        love.graphics.draw(self.texture, self.visualx, self.visualy, self.dimensions['rotation'] * self.player.orientation, self.player.orientation, 1, 8)
    elseif self.downSpike then
        love.graphics.draw(self.texture, self.visualx, self.visualy, 0 * self.player.orientation, self.player.orientation, 1, 8)
    end
end

function Weapon:downSpikeActive()
    if self.downSpike then
        for k, enemy in pairs(self.player.enemies) do
            if self:collides(enemy) then
                if not enemy.iFrames then
                    enemy.iFrames = true
                    enemy:wasHit(self.player.strength + 1)
                    Timer.after(0.4, function()
                        enemy.iFrames = false end)
                    return true
                end
            end
        end
    end
    return false
end