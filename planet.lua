local libclass = require("lib.class")
local layer = require("layer")
local transform = require("transform")

local globe_img, cloud_img

Planet = class()

function Planet:load()
    globe_img = love.graphics.newImage("assets/env/globe.png")
    cloud_img = love.graphics.newImage("assets/env/clouds.png")
end

function Planet:_new(x, y)
    --outside: read only plz
    self.x = x
    self.y = y

    self.layers = {}
    local t = Transform(self.x, self.y, 0, 2)
    table.insert(self.layers, Layer(globe_img, t))
    local t = t:clone()
    table.insert(self.layers, Layer(cloud_img, t))

    self.consumption = {}
    self.stock = {}
    self.orbitals = {}
end

function Planet:update(dt)
    for i, L in ipairs(self.layers) do
        L:rotate(6/10000/i)
    end
end

function Planet:draw()
    for _, L in ipairs(self.layers) do
        L:draw()
    end
end

