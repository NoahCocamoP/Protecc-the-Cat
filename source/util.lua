function GenerateQuads(sprites, height, width)
    local x_chunks = sprites:getWidth() / width
    local y_chunks = sprites:getHeight() / height

    local counter = 1

    local spritesheet = {}
    for y = 0, y_chunks - 1 do
        for x = 0, x_chunks - 1 do
            spritesheet[counter] = love.graphics.newQuad(x * width, y * height, width, height, sprites:getDimensions())
            counter = counter + 1
        end
    end
    return spritesheet
end