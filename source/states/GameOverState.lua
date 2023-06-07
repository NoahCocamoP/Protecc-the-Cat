GameOverState = Class{__includes = BaseState}

function GameOverState:enter(player)
    self.player = player

    self.background = Backgrounds[2]

    self.fadeOut = {
        ['opacity'] = 0,
        ['fadedOut'] = false
    }

    Sounds['battle-music']:stop()
    Sounds['title-theme']:play()
end

function GameOverState:update(dt)
    self:transition()
end

function GameOverState:render()
    love.graphics.clear(1, 1, 1)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("You died :(", VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT * 1/3 - 30)
    love.graphics.print("Final Score: " .. tostring(self.player.score), VIRTUAL_WIDTH / 2 - 65, VIRTUAL_HEIGHT * 1/2 - 30)
    love.graphics.print("Press R to play again!", VIRTUAL_WIDTH / 2 - 80, VIRTUAL_HEIGHT * 2/3 - 30)
    love.graphics.setColor(1, 1, 1, self.fadeOut['opacity'])
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(1, 1, 1, 1)
end

function GameOverState:transition()
    if love.keyboard.wasPressed('r') and not self.fadeOut['fadedOut'] then
        Sounds['enter']:play()
        self.fadeOut['fadedOut'] = true
        Timer.tween(1.25, {
            [self.fadeOut] = {['opacity'] = 1}
        }):finish(function() gameState:change('select') end)
    end
end
