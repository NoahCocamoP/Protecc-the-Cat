EnemyFalling = Class{__includes = BaseState}

function EnemyFalling:enter(enemy)
    self.enemy = enemy

    self.player = self.enemy.player

    self.tilemap = self.enemy.tilemap

    self.animation = Animation({
        interval = 1,
        frames = {1}
    })

    self.enemy.currentAnimation = self.animation
end

function EnemyFalling:update(dt)
    self.enemy.dy = self.enemy.dy + (GRAVITY * dt)
    for k, tile in pairs(self.tilemap) do
        if tile.isSolid then
            if self.enemy:collides(tile) then
                self.enemy.dy = 0
                self.enemy:change("wandering", self.enemy)
            end
        end
    end
end