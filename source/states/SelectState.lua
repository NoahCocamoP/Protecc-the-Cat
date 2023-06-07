SelectState = Class{__includes = BaseState}

function SelectState:init()
    self.characterSelected = 0
    self.texture = 'characters'
    self.background = Backgrounds[math.random(1, 3)]
    self.leftVisibility = 0
    self.rightVisibility = 1
end

function SelectState:update(dt)
    self:weaponSelect()
    if love.keyboard.wasPressed('left') then
        if self.characterSelected == 0 then
            Sounds['no-select']:play()
        else
            Sounds['select']:play()
            self.characterSelected = self.characterSelected - 1
        end
    end
    if love.keyboard.wasPressed('right') then
        if self.characterSelected == 3 then
            Sounds['no-select']:play()
        else
            Sounds['select']:play()
            self.characterSelected = self.characterSelected + 1
        end
    end
    self:arrowVisibility()
    if love.keyboard.wasPressed('return') then
        Sounds['enter']:play()
        gameState:change("play", {
            background = self.background,
            character = self.characterSelected,
            weaponTexture = self.weaponTexture
        })
    end
end

function SelectState:render()
    -- The numbers for the x and y axis on these are just what made them fit properly.
    love.graphics.draw(self.background,-self.background:getWidth() * 0.5, -self.background:getHeight() * 0.75)
    love.graphics.printf("Select Your Character", 256 - 125, 60, 200, 'center')
    love.graphics.draw(gTextures[self.texture], gQuads[self.texture][2 + (self.characterSelected * 9)], 256 - 45, 100, 0, 2, 2)
    love.graphics.printf(NAMES[self.characterSelected + 1], 256 - 75, 170, 100, 'center')
    love.graphics.setColor(1, 1, 1, self.leftVisibility)
    love.graphics.draw(gTextures['left-arrow'], 256 - 110, 120)
    love.graphics.setColor(1, 1, 1, self.rightVisibility)
    love.graphics.draw(gTextures['right-arrow'], 276, 120)
    love.graphics.setColor(1, 1, 1, 1)
end

function SelectState:arrowVisibility()
    if love.keyboard.wasPressed('left') and self.characterSelected ~= 0 then
        self.rightVisibility = 1
        self.leftVisibility = 0.5
        Timer.after(0.25, function() self.leftVisibility = 1 end)
    end
    if love.keyboard.wasPressed('right') and self.characterSelected ~= 3 then
        self.leftVisibility = 1
        self.rightVisibility = 0.5
        Timer.after(0.25, function() self.rightVisibility = 1 end)
    end
    if self.characterSelected == 3 then
        self.rightVisibility = 0
    end
    if self.characterSelected == 0 then
        self.leftVisibility = 0
    end
end

function SelectState:weaponSelect()
    if self.characterSelected == 0 or self.characterSelected == 1 then
        self.weaponTexture = Weapons[1]
    else
        self.weaponTexture = Weapons[2]
    end
end
