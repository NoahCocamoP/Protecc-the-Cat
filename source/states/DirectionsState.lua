DirectionsState = Class{__includes = BaseState}

function DirectionsState:init()
    self.counter = 0
    -- Values for tweening transparency of each line
    self.directions = {
        ['line1'] = 0,
        ['line2'] = 0,
        ['line3'] = 0,
        ['line4'] = 0
    }
end

function DirectionsState:update(dt)
    self:tweenDirections()
    if love.keyboard.wasPressed('return') then
        Sounds['enter']:play()
        if self.counter == 3 then
            gameState:change("select")
        end
        self.counter = self.counter + 1
    end
end

function DirectionsState:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Backgrounds[2], 0, -Backgrounds[2]:getHeight() * 0.6)
    love.graphics.setColor(1, 1, 1, self.directions['line1'])
    love.graphics.print("Press Q to attack", 100, 30)
    love.graphics.setColor(1, 1, 1, self.directions['line2'])
    self:drawArrows()
    love.graphics.setColor(1, 1, 1, self.directions['line3'])
    love.graphics.print("Press Space to jump", 190, 160)
    love.graphics.setColor(1, 1, 1, self.directions['line1'])
    love.graphics.print("Press Enter to continue", 50, VIRTUAL_HEIGHT - 30)
    love.graphics.setColor(1, 1, 1, self.directions['line4'])
    love.graphics.print("Press P to pause during battle", 230, 210)
    love.graphics.setColor(1, 1, 1, 1)
end

function DirectionsState:drawArrows()
    love.graphics.draw(gTextures['left-arrow'], 170, 80)
    love.graphics.draw(gTextures['right-arrow'], 200, 80)
    love.graphics.print("To Move", 170, 100)
end

function DirectionsState:tweenDirections()
    if self.counter == 0 then
        Timer.tween(0.3, {
            [self.directions] = {['line1'] = 1}
        })
    elseif self.counter == 1 then
        Timer.tween(0.3, {
            [self.directions] = {['line2'] = 1}
        })
    elseif self.counter == 2 then
        Timer.tween(0.3, {
            [self.directions] = {['line3'] = 1}
        })
    elseif self.counter == 3 then
        Timer.tween(0.3, {
            [self.directions] = {['line4'] = 1}
        })
    end
end