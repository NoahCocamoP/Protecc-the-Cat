Health = Class{}

function Health:init(points, entity)
    self.total = points

    self.owner = entity

    self.current = points

    self.x = self.owner.x - 9

    self.y = self.owner.y - 10

    self.health = {
        ['previous'] = self.current,
        ['current'] = self.current
    }
end

function Health:update()
    self.x = self.owner.x - 9
    self.y = self.owner.y - 10
end

function Health:change(amount)
    self.current = self.current - amount
    if self.current < 0 then
        self.current = 0
    end
    self.health['current'] = self.current
    self:tween()
end

function Health:empty()
    if self.current < 1 then
        return true
    else
        return false
    end
end

function Health:tween()
    if self.health['previous'] ~= self.health['current'] and self.health['current'] > -1 then
        Timer.tween(0.5, {
            [self.health] = {['previous'] = self.current}
        })
    end
end

function Health:render()
    -- Bar outline
    love.graphics.rectangle('line', self.x, self.y, 20, 4)
    -- Red bar
    if self.health['previous'] / self.total > 1/3 then
        love.graphics.setColor(0, 1, 0, 1)
    else
        love.graphics.setColor(1, 0, 0, 1)
    end
    love.graphics.rectangle('fill', self.x, self.y, 20 * (self.health['previous'] / self.total), 3)
    love.graphics.setColor(1, 1, 1, 1)
end

function Health:reset(points)
    self.current = points
    self.total = points
    self.health['previous'] = self.current
    self.health['current'] = self.current
end

