StartState = Class{__includes = BaseState}

function StartState:enter()
    self.background = Backgrounds[2]
    self.titleBox = {
        ['X'] = VIRTUAL_WIDTH + 200,
        ['Y'] = 70,
        ['Transparency'] = 0
    }    Timer.tween(2, {
        [self.titleBox] = {['X'] = 75}
    }):finish(function() Timer.tween(0.5,
        {
            [self.titleBox] = {['Transparency'] = 1}
        }) end)
        Sounds['title-theme']:setLooping(true)
        Sounds['title-theme']:setVolume(0.2)
        Sounds['battle-music']:setLooping(true)
        Sounds['battle-music']:setVolume(0.25)
        Sounds['title-theme']:play()
end

function StartState:update(dt)
    if love.keyboard.wasPressed('return') then
        Timer.clear()
        Sounds['enter']:play()
        gameState:change("directions")
    end
end

function StartState:render()
    -- Draw background first
    love.graphics.draw(self.background, 0, -self.background:getHeight() * 0.6)
    -- Then draw the title box
    -- Then print the Title
    love.graphics.setColor(255/255, 30/255, 255/255, 1)
    love.graphics.setFont(Fonts['to-the-point-large'])
    love.graphics.print("Protecc the Cat", self.titleBox['X'] + 30, self.titleBox['Y'])
    love.graphics.setColor(1, 1, 1, self.titleBox['Transparency'])
    love.graphics.print("Press Enter to Start", VIRTUAL_WIDTH / 2 - 30, VIRTUAL_HEIGHT * 0.75)
    love.graphics.setColor(1, 1, 1, 1)
end