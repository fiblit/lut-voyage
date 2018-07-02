local libclass = require("lib.class")
local c_transform = require("transform")

local glow

Star = class()
function Star.load()
    glow = love.graphics.newImage("assets/env/glow.png")
end

function Star:_new(xmin, xmax, ymin, ymax, s)
    -- outside: read only please
    self.x = math.random(xmin, xmax)
    self.y = math.random(ymin, ymax)

    self.layer = Layer(glow, Transform(self.x, self.y, 0, s))
end

function Star:update(dt)
    local r = love.math.noise(love.timer.getTime() + self.x + self.y)
    local min_b = 0.3
    local max_b = 1
    local bright = r * (max_b - min_b) + min_b
    self.layer.color = {bright, bright, bright, bright}
end

function Star:draw()
    self.layer:draw()
end

