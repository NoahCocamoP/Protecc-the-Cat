TransitionState = Class{__includes = BaseState}

function TransitionState:enter(player)
    self.player = player

    self.background = Backgrounds[math.random(1, 3)]

    self.player.level = self.player.level + 1

    self.fadeIn = {
        ['opacity'] = 1
    }

    self.fadedIn = false

    self.bonusScore = {
        ['bonus'] = (self.player.health.current - 1) * 100 * self.player.level,
        ['current'] = self.player.score
    }

    self.bonusEffectStart = false

    self.bonusEffectFinished = false

    self.fadedOut = false

    if self.player.health.current < 2 then
        self.noBonus = true
    end
end

function TransitionState:update(dt)
    -- Screen fade in effect
    self:screenFadeIn()
    -- Check to see if enter was pressed and if so then we can continue to the upgrades state. 
    self:continue()
    -- Bonus point effect
    self:pointBonusEffect()
    -- To make the tweens only count in whole numbers.
    self.bonusScore['bonus'] = math.floor(self.bonusScore['bonus'])
    self.player.score = math.floor(self.bonusScore['current'])
end

function TransitionState:render()
    love.graphics.draw(Backgrounds[2], 0, -self.background:getHeight() + VIRTUAL_HEIGHT)
    love.graphics.setColor(0, 0, 0, 1)
    if self.bonusScore['bonus'] ~= 0 and not self.noBonus then
        love.graphics.print("Remaining Health Bonus: " .. tostring(self.bonusScore['bonus']), VIRTUAL_WIDTH / 2 - 85, VIRTUAL_HEIGHT * (1/3) - 80)
    end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures[self.player.cat.texture], VIRTUAL_WIDTH - 40, VIRTUAL_HEIGHT / 2, 0, 2, 2)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("Current Score: " .. tostring(self.player.score), VIRTUAL_WIDTH / 2 - 85, VIRTUAL_HEIGHT * (1/3) - 50)
    love.graphics.print("Next Level: ".. tostring(self.player.level), VIRTUAL_WIDTH / 2 - 85, VIRTUAL_HEIGHT * (2/3) - 70)
    love.graphics.print("Press Enter to Continue", VIRTUAL_WIDTH / 2 - 85, VIRTUAL_HEIGHT - 100)
    love.graphics.setColor(1, 1, 1, self.fadeIn['opacity'])
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(1, 1, 1, 1)
end


function TransitionState:continue()
    if love.keyboard.wasPressed('return') and (self.bonusEffectFinished or self.noBonus) then
        Sounds['enter']:play()
        self.fadedOut = true
        -- Reset players x, y, dx, and dy values so that we're not where we were when we finished the last level.
        self.player.x = 20
        self.player.y = 30
        self.player.dx = 0
        self.player.dy = 0
        self.player.health:reset(self.player.health.total + 1) 
        Timer.tween(0.75, {
            [self.fadeIn] = {['opacity'] = 1}
        })
        Timer.after(0.8, function() 
            gameState:change('upgrades', {
            background = self.background,
            player = self.player
        }) end)
    end
end

function TransitionState:screenFadeIn()
    if self.fadedIn == false then
        self.fadedIn = true
        Timer.tween(0.75, {
            [self.fadeIn] = {['opacity'] = 0}
        })
    end
end

function TransitionState:pointBonusEffect()
    if not self.noBonus and not self.bonusEffectStart then
        self.bonusEffectStart = true
        Timer.after(1.5,
        function()
            Sounds['bonus']:play()
            Timer.tween(1.25,
        {
            [self.bonusScore] = {['current'] = self.player.score + self.bonusScore['bonus']}
        })
        Timer.tween(1.25,
        {
            [self.bonusScore] = {['bonus'] = 0 }
        }):finish(function() self.bonusEffectFinished = true end)
        end)
    end
end