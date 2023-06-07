EnemyWandering = Class{__includes = BaseState}

function EnemyWandering:enter(enemy)
    self.enemy = enemy

    self.player = self.enemy.player

    self.animation = Animation({
        interval = 0.2,
        frames = {5, 6, 7, 8}
    })

    self.enemy.currentAnimation = self.animation
    
    self.wanderingActive = false

    self.enemy.dx = (PLAYER_WALK_SPEED * 0.75) * (math.random(2) == 1 and -1 or 1)
end

function EnemyWandering:update(dt)
    if not self.enemy:aboveTile() then
        if wandering then
            wandering:remove()
        end
        self.enemy:change("falling", self.enemy)
    end
    if math.random(1000) == 1000 then
        if wandering then
            wandering:remove()
        end
        self.enemy:change('jump', self.enemy)
    end
    if math.abs(self.enemy.x - self.player.x) < 60 then
        if wandering then
            wandering:remove()
        end
        self.enemy:change("attacking", self.enemy)
    
    elseif not self.wanderingActive then
        if wandering then
            wandering:remove()
        end
        self.wanderingActive = true
        local wandering = Timer.after(math.random(6), function()
        self.enemy.dx = math.random(0, 1) == 1 and PLAYER_WALK_SPEED * 0.75 or -PLAYER_WALK_SPEED * 0.75
        self.wanderingActive = false
        end)
    end
end
