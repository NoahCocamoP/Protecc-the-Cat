love.graphics.setDefaultFilter("nearest", "nearest")
require 'source/dependencies'

function love.load()
    love.window.setTitle('Protecc the Cat')
    -- Random adjustment to make the volume of this effect more bareable 
    Sounds['select']:setVolume(0.5)
    
    math.randomseed(os.time())
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
{
    vsync = true,
    fullscreen = false,
    resizable = true,
    canvas = false
})


gameState = StateMachine {
    ['play'] = function() return PlayState() end,
    ['select'] = function() return SelectState() end,
    ['start'] = function() return StartState() end,
    ['directions'] = function() return DirectionsState() end,
    ['transition'] = function() return TransitionState() end,
    ['upgrades'] = function() return UpgradesState() end,
    ['game-over'] = function() return GameOverState() end
}

gameState:change('start')

love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    -- Timer.update in main so that our Timers are updated regardless of state
    Timer.update(dt)

    gameState:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gameState:render()
    push:finish()
end