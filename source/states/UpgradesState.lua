UpgradesState = Class{__includes = BaseState}

function UpgradesState:enter(params)
    self.background = params.background

    self.player = params.player

    self.potionSelected = 2

    self.potionOpacity1 = {0.5}

    self.potionOpacity2 = {0.5}

    self.potionOpacity3 = {0.5}

    self.fadedOut = false

    self.fadeEffect = {0, 1}

    self.fadedIn = false

end


function UpgradesState:update(dt)
    self:fadeIn()
    self:potionSelect()
    self:potionHighlights()
    self:fadeOut()
end


function UpgradesState:render()
    love.graphics.clear(1, 1, 1)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures[self.player.texture], gQuads[self.player.texture][2 + (9 * self.player.character)], 80, VIRTUAL_HEIGHT / 2 - 20, 0, 2, 2)
    love.graphics.draw(gTextures[self.player.cat.texture], 70, VIRTUAL_HEIGHT / 2 + 10, 0, -1.2, 1.2)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("Pick an Upgrade!", VIRTUAL_WIDTH / 2 - 58, VIRTUAL_HEIGHT * 1/3 - 30)
    love.graphics.printf(Potions[self.potionSelected], VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT * 0.75 - 35, 100, 'center')
    love.graphics.setColor(1, 1, 1, self.potionOpacity1[1])
    love.graphics.draw(gTextures['potions'], gQuads['potions'][1], VIRTUAL_WIDTH / 2 - 60, VIRTUAL_HEIGHT / 2 - 30, 0, 2, 2)
    love.graphics.setColor(1, 1, 1, self.potionOpacity2[1])
    love.graphics.draw(gTextures['potions'], gQuads['potions'][2], VIRTUAL_WIDTH / 2 - 20, VIRTUAL_HEIGHT / 2 - 30, 0, 2, 2)
    love.graphics.setColor(1, 1, 1, self.potionOpacity3[1])
    love.graphics.draw(gTextures['potions'], gQuads['potions'][3], VIRTUAL_WIDTH / 2 + 20, VIRTUAL_HEIGHT / 2 - 30, 0, 2, 2)
    love.graphics.setColor(1, 1, 1, self.fadeEffect[1])
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(1, 1, 1, self.fadeEffect[2])
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(1, 1, 1, 1)
end


function UpgradesState:potionSelect()
    if love.keyboard.wasPressed('left') and self.potionSelected ~= 1 then
        Sounds['select']:play()
        self.potionSelected = self.potionSelected - 1
    elseif love.keyboard.wasPressed('left') then
        self.potionSelected = 3
        Sounds['select']:play()
    end
    if love.keyboard.wasPressed('right') and self.potionSelected ~= 3 then
        Sounds['select']:play()
        self.potionSelected = self.potionSelected + 1
    elseif love.keyboard.wasPressed('right') then
        Sounds['select']:play()
        self.potionSelected = 1
    end
end


function UpgradesState:potionHighlights()
    if self.potionSelected == 1 then
        self.potionOpacity1[1] = 1
    else
        self.potionOpacity1[1] = 0.5
    end
    if self.potionSelected == 2 then
        self.potionOpacity2[1] = 1
    else
        self.potionOpacity2[1] = 0.5
    end
    if self.potionSelected == 3 then
        self.potionOpacity3[1] = 1
    else
        self.potionOpacity3[1] = 0.5
    end
end


function UpgradesState:fadeOut()
    if love.keyboard.wasPressed('return') and not self.fadedOut then
        Sounds['enter']:play()
        self.fadedOut = true
        self:applyPotion()
        Sounds["glug"]:play()
        Timer.tween(1.5,
        {
            [self.fadeEffect] = {[1] = 1}
        }):finish(function()
        gameState:change('play', {
            player = self.player,
            background = Backgrounds[math.random(1, #Backgrounds)]
        }) end)
    end
end


function UpgradesState:applyPotion()
    if self.potionSelected == 1 then
        self.player.speed = self.player.speed + 15
    elseif self.potionSelected == 2 then
        self.player.health:reset(self.player.health.total + 3)
    elseif self.potionSelected == 3 then
        self.player.strength = self.player.strength + 1
    end
end


function UpgradesState:fadeIn()
    if not self.fadedIn then
        self.fadedIn = true
        Timer.tween(1, {
            [self.fadeEffect] = {[2] = 0}
        })
    end
end