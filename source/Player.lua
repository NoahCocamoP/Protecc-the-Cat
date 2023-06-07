Player = Class{__includes = Entity}

function Player:init(params)
    self.character = params.character

    self.states = params.states
    
    self.texture = params.texture

    self.currentBackground = params.background

    self.width = 16
    self.height = 28

    self.x = 0 + self.width
    self.y = 5

    self.dx = 0
    self.dy = 0

    self.direction = 'right'

    self.tilemap = params.tiles
    -- self.orientation is used as a scaling x-axis factor for rendering the character sprite and weapon sprite. When self.direction == 'right' then self.orientation will be 1
    -- when self.direction == 'left' then self.orientation will == -1
    self.orientation = 1
    
    self.weapon = Weapon({
        texture = params.weaponTexture,
        player = self
    })
    
    -- Used as a holder for the output of the tileCollisions function. The function will check each tile for a collision between the player and tile. If there is a collision, it finds
    -- the shortest route to move the player/entity outside of the tile, and moves them out. It then returns what direction it moved them out towards - for example if the player collided
    -- with the top of the tile then it'll move them out again to the top, and output 'up'.

    -- Ultimately this variable is then used to solve a glitch with a falling entity repeteadly falling into and being pushed out of a tile.
    self.collisionDirection = 'none'

    -- Health points being initialized.
    self.health = Health(12, self)

    self.cat = Cat(self)

    self.score = 0
    -- self.level is used to calculate scoring for enemy kills, as well as is used to scale the amount of enemies that spawn and the hp they have.
    self.level = 1

    -- iFrames stands for Invincibility Frames, when iFrames is true then the player won't be able to recieve damage.
    self.iFrames = false

    -- For damage calculations against enemies
    self.strength = 1
    -- Using a self-variable for players speed so that it can be upgraded later on, without having to change the global PLAYER_WALK_SPEED
    self.speed = PLAYER_WALK_SPEED
    -- Used to tell if we're falling so we can know if we need to do a normal swing with q or only a downspike.
    self.isFalling = false
    -- Used to tell if we're jumping so we can know if we need to do a normal swing with q or only a downspike.
    self.jumping = false
end

function Player:update(dt)
    -- updateDirection function is contained in the entity class. It handles with updating self.direction according to the momentum on the x-axis (self.dx)
    self:updateDirection()
    -- updateOrientation is also contained in the entity class. It updates the orientation (which handles what direction to draw the player facing) based on self.direction
    self:updateOrientation()
    self.weapon:update(dt)
    self:constrainMovement()
    self:updateMovement(dt)
    self.health:update(dt)

    self.states:update(dt)
    self:swingSword()
    self:hitsEnemy()
    self.collisionDirection = self:tileCollisions(self.tilemap)
    self:negateMomentum()
    self.cat:update(dt)
end

function Player:change(state, params)
    self.states:change(state, params)
end

function Player:render()
    self.weapon:render()
    self.cat:render()
    self.states:render()
    self.health:render()
end


function Player:swingSword()
    if (love.keyboard.wasPressed('q') or love.keyboard.wasPressed('Q')) and not self.weapon.downSpike and not self.isFalling and not self.jumping then
        self.weapon.hitting = true
        self.weapon:animateSwing()
    end
end

function Player:hitsEnemy()
    for k, enemy in pairs(self.enemies) do
        if self.weapon:collides(enemy) then
            if self.weapon.hitting then
                if not enemy.iFrames then
                    enemy.iFrames = true
                    enemy:wasHit(self.strength)
                    Timer.after(0.4, function()
                    enemy.iFrames = false end)
                end
            end
        end
    end
end
