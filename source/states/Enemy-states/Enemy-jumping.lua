EnemyJumping = Class{__includes = BaseState}

function EnemyJumping:enter(enemy)
    self.enemy = enemy

    self.player = self.enemy.player

    self.enemy.dy = -150

    self.animation = Animation({
        interval = 1,
        frames = {2}
    })
    self.enemy.currentAnimation = self.animation
end

function EnemyJumping:update(dt)
    self.enemy.dy = self.enemy.dy - (GRAVITY * dt)
    if self.enemy.dy < 1 then
        self.enemy:change('falling', self.enemy)
    end
end
