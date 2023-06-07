PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    Sounds['title-theme']:stop()
    Sounds['battle-music']:setVolume(0.25)
    Sounds['battle-music']:play()
    self.background = params.background
    self.map = LevelMaker(self.background)
    if params.player then
        self.player = params.player
        self.player.tilemap = self.map.tilemap
        self.player.background = params.background
    else
        self.player = Player({texture = 'characters',
                            states = StateMachine{
                                ['idle'] = function() return Player_idle() end,
                                ['walking'] = function() return Player_walking() end,
                                ['falling'] = function() return Player_falling() end,
                                ['jump'] = function() return Player_jumping() end
                            },
                            background = self.background,
                            character = params.character,
                            tiles = self.map.tilemap,
                            weaponTexture = params.weaponTexture})
                        end
    self.player:change('falling', self.player)
    self.camX = 0
    self.camY = 0
    self.backgroundX = 0
    self.enemies = {}
    self.enemiesGenerated = false
    -- Boolean to only deal with going to transition state one time.
    self.victory = false
    -- Boolean to tell if the game is paused. If it is, we pause the updates and render a pause button.
    self.paused = false

    self.isGameOver = false
    -- Table for tweening values related to the game over effect and state transition
    self.GameOver = {
        ['opacity'] = 0,
        ['volume'] = 0.25
    }
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('l') then
        Sounds['battle-music']:stop()
        gameState:change('upgrades', {
            player = self.player,
            background = Backgrounds[2]
        })
    end
    Sounds['battle-music']:setVolume(self.GameOver['volume'])
    self:pauseGame()
    -- This whole line was a funny workaround that I had to do, because enemies needed a reference to player and tilemap but player needs a reference to tilemap.
    -- So I decided to generate enemies inside of the playstate, after LevelMaker made the tiles and self.player was instantiated.
    -- Then I pass a reference of enemies to player in "self.player.enemies". I also had to make a boolean called self.enemiesGenerated
    -- because I only want enemies to generate one time lol
    if self.enemiesGenerated == false then
        self:generateEnemies()
        self.player.enemies = self.enemies
        self.enemiesGenerated = true
    end
    self:itsGameOver()
    if not self.paused then
        for k, enemy in pairs(self.enemies) do
            enemy:update(dt)
            if enemy.health.health['previous'] == 0 then
                Sounds['enemy-death']:play()
                table.remove(self.enemies, k)
                if enemy.isPowerful then
                    self.player.score = self.player.score + 250 + (500 * self.player.level)
                else
                    self.player.score = self.player.score + 250 + (250 * self.player.level)
                end
            end
        end
        self.player:update(dt)
        self:updateCameras()
        -- function for handling the winning condition of the level (defeating all the enemies)
        self:Victory()
    end
end

function PlayState:render()
    love.graphics.translate(0, 0)
    self:drawBackground()
    love.graphics.print("Score: " .. tostring(self.player.score), 20, 12)
    love.graphics.translate(-math.floor(self.camX), 0)
    for k, tile in pairs(self.map.tilemap) do
        tile:render()
    end
    for k, enemy in pairs(self.enemies) do
        enemy:render()
    end
    self.player:render()
    love.graphics.translate(math.floor(self.camX), 0)
    self:renderPause()
    love.graphics.setColor(1, 1, 1, self.GameOver['opacity'])
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.translate(0, 0)
    love.graphics.setColor(1, 1, 1, 1)
end

function PlayState:updateCameras()
    -- Sets the camera to start rendering from left to right once the player is halfway across the screen, and then once they're at the last section of the level
    -- the math.min stops the player from translating their position past where the background ends.
    self.camX = math.max(0, math.min(self.player.x - (VIRTUAL_WIDTH / 2 - 9), self.background:getWidth() - (VIRTUAL_WIDTH) - 9))
    self.backgroundX = self.camX / 3
end

function PlayState:drawBackground()
    love.graphics.draw(self.background, math.floor(-self.backgroundX), -self.background:getHeight() + (VIRTUAL_HEIGHT * 1.5))
end

function PlayState:generateEnemies()
    local difficulty = math.max(3, 11 - self.player.level)
    for k, tile in pairs(self.map.tilemap) do
        if tile.isTop and math.random(difficulty) == difficulty and tile.x > 124 then
            local enemy = Enemy({
                background = self.background,
                texture = EnemyTypes[math.random(1, #EnemyTypes)],
                y = tile.y - TILE_HEIGHT * 2,
                x = tile.x,
                tilemap = self.map.tilemap,
                width = 16,
                height = 20,
                player = self.player,
                isPowerful = math.random(difficulty) == 1 and true or false,
                states = StateMachine({
                    ['falling'] = function() return EnemyFalling() end,
                    ['wandering'] = function() return EnemyWandering() end,
                    ['attacking'] = function() return EnemyAttacking() end,
                    ['jump'] = function() return EnemyJumping() end
                })

            })
            table.insert(self.enemies, enemy)
            enemy:change('falling', enemy)
        end
    end
end

function PlayState:Victory()
    if #self.enemies == 0 and self.victory == false then
        Sounds['battle-music']:stop()
        self.victory = true
        Sounds['level-complete']:play()
        Timer.after(3, function()
        gameState:change("transition", self.player)
        end)
    end
end

function PlayState:pauseGame()
    if love.keyboard.wasPressed('p') then
        if self.paused then
            self.paused = false
            Sounds['battle-music']:play()
            Sounds['enter']:play()
        else
            self.paused = true
            Sounds['battle-music']:pause()
            Sounds['enter']:play()
        end
    end
end

function PlayState:renderPause()
    if self.paused then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 50, 30, 40, 100)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2, 30, 40, 100)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function PlayState:itsGameOver()
    if self.player.health.current < 1 and not self.isGameOver then
        self.isGameOver = true
        Timer.tween(1.25, {
            [self.GameOver] = {['opacity'] = 1}
        })
        Timer.tween(1.25, {
            [self.GameOver] = {['volume'] = 0}
        }):finish(function() gameState:change('game-over', self.player) end)
    end
end

