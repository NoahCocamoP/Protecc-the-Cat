Animation = Class{}

function Animation:init(params)
    self.frames = params.frames
    self.interval = params.interval
    self.timer = 0
    self.current = 1
end

function Animation:update(dt)
    if #self.frames ~= 1 then
        self.timer = self.timer + dt
        if self.timer > self.interval then
            self.timer = self.timer % self.interval

            self.current = math.max(1, (self.current + 1) % (#self.frames + 1))
        end
    end
end

function Animation:getFrame()
    return self.frames[self.current]
end