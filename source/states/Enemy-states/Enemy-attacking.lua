EnemyAttacking = Class{__includes = BaseState}

function EnemyAttacking:enter(enemy)
    self.enemy = enemy

    self.player = self.enemy.player

    self.chillOut = false
end

function EnemyAttacking:followPlayer()
    self:chillBro()
    if self.enemy.x + 60 < self.player.x or self.enemy.x - 60 > self.player.x then
        self.enemy:change('wandering', self.enemy)
    elseif self.enemy.x > self.player.x and self.enemy.collisionDirection == 'none' and self.chillOut == false then
        self.enemy.dx = -PLAYER_WALK_SPEED * 0.75
    elseif self.enemy.collisionDirection == 'none' and self.chillOut == false then
        self.enemy.dx = PLAYER_WALK_SPEED * 0.75
    else
        self.enemy.dx = 0
    end
    self:jumps()
end

function EnemyAttacking:update(dt)
    self:followPlayer()
    if not self.enemy:onTile(self.player.tilemap) then
        self.enemy:change("falling", self.enemy)
    end
end

function EnemyAttacking:chillBro()
    if self.enemy.collisionDirection ~= "none" then
        self.chillOut = true
        Timer.after(1.5, function() self.chillOut = false end)
    end
end

function EnemyAttacking:jumps()
    if self.player.y + 50 < self.enemy.y then
        self.enemy:change('jump', self.enemy)
    end
end