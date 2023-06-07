LevelMaker = Class{}

function LevelMaker:init(background)
    local total_y = math.floor(VIRTUAL_HEIGHT / TILE_HEIGHT)
    local total_x = math.floor(background:getWidth() / TILE_WIDTH)

    local tileType = TILE_TYPE[math.random(1, 2)]

    local columnStop = false

    local columnTracker = 0

    local top = 9

    self.tilemap = {}

    for x = 1, total_x do

        local additionalTile = math.random(10) == 10 and true or false
        -- stopping columns from generating too close to each other
        if not columnStop then 
            top = math.random(12) == 8 and 7 or 10
        else
            top = 10
        end

        for y = 1, total_y do

            if y == top - 1 and math.random(6) == 1 then
                -- insert plant before tile so that it looks like plant is coming out of the ground
                table.insert(self.tilemap, 
            Tile({
                texture = 'plants',
                type = math.random(1, 60),
                tileX = (x - 1) * TILE_WIDTH,
                tileY = (y - 1) * TILE_HEIGHT + 5,
                isTop = false,
                isSolid = false
            }))
        end
        -- Code for generating extra tiles
        if not columnStop then
            if y == top - 3 and additionalTile then
                table.insert(self.tilemap,
                Tile({
                    texture = tileType,
                    type = 3,
                    tileX = (x - 1) * TILE_WIDTH,
                    tileY = (y - 1) * TILE_HEIGHT,
                    isTop = y == top and true or false,
                    isSolid = true
                }))
            end
        else
            if y == top - 6 and additionalTile then
                table.insert(self.tilemap,
                Tile({
                    texture = tileType,
                    type = 3,
                    tileX = (x - 1) * TILE_WIDTH,
                    tileY = (y - 1) * TILE_HEIGHT,
                    isTop = y == top and true or false,
                    isSolid = true
                }))
            end
        end

            if y > top - 1 then
                -- insert solid tiles
                table.insert(self.tilemap,
                Tile({
                    texture = tileType,
                    type = y == top and 3 or 6,
                    tileX = (x - 1) * TILE_WIDTH,
                    tileY = (y - 1) * TILE_HEIGHT,
                    isTop = y == top and true or false,
                    isSolid = true
                }))
            end
        end
        -- stopping columns from generating too close to each other
        if top == 7 and columnStop == false then
            columnStop = true

            columnTracker = x
        end
        if columnTracker + 3 == x then
            columnStop = false
        end

    end
end