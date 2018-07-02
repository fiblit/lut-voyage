-- todo: camera following Voyager

local libclass = require("lib.class")
local layer = require("layer")
local transform = require("transform")
local anim = require("anim")

local hull_0, decal_0, cockpit_0
local heat_0, heat_1, heat_2, heat_3, heat_4, heat_5, heat_6, heat_7, heat_8,
    heat_9, heat_10, heat_11

Voyager = class()
function Voyager.load()
    hull_0 = love.graphics.newImage("assets/voyager/hull_0.png")
    decal_0 = love.graphics.newImage("assets/voyager/decal_0.png")
    cockpit_0 = love.graphics.newImage("assets/voyager/cockpit_0.png")
    heat_0 = love.graphics.newImage("assets/voyager/heat_0.png")
    heat_1 = love.graphics.newImage("assets/voyager/heat_1.png")
    heat_2 = love.graphics.newImage("assets/voyager/heat_2.png")
    heat_3 = love.graphics.newImage("assets/voyager/heat_3.png")
    heat_4 = love.graphics.newImage("assets/voyager/heat_4.png")
    heat_5 = love.graphics.newImage("assets/voyager/heat_5.png")
    heat_6 = love.graphics.newImage("assets/voyager/heat_6.png")
    heat_7 = love.graphics.newImage("assets/voyager/heat_7.png")
    heat_8 = love.graphics.newImage("assets/voyager/heat_8.png")
    heat_9 = love.graphics.newImage("assets/voyager/heat_9.png")
    heat_10 = love.graphics.newImage("assets/voyager/heat_10.png")
    heat_11 = love.graphics.newImage("assets/voyager/heat_11.png")
end

function Voyager:_new(x, y, ox, oy)
    --outside: read only plz
    self.x = x
    self.y = y
    self.ox = ox --ideally 0
    self.oy = oy --ideally 0

    self.layers = {}
    local t = Transform(self.x, self.y, 0, -2, 2, self.ox, self.oy)
    table.insert(self.layers, Layer(hull_0, t))
    local t = t:clone()
    table.insert(self.layers, Layer(decal_0, t))
    local t = t:clone()
    table.insert(self.layers, Layer(cockpit_0, t))
    local t = t:clone()
    local a = Anim(0.42, {
        heat_0, heat_1, heat_2, heat_3, heat_4, heat_5,
        heat_6, heat_7, heat_8, heat_9, heat_10, heat_11
    })
    a:play()
    table.insert(self.layers, Layer(a, t))
end

function Voyager:update(dt)
    -- demo rotate around menu planet
    for _, L in ipairs(self.layers) do
        L:update(dt)
        L:rotate(2/1000)
    end

    -- glow cockpit
    local r = love.math.noise(love.timer.getTime())
    local min_b = 0.3
    local max_b = 0.8
    local bright = r * (max_b - min_b) + min_b
    self.layers[3].color = {bright - 0.2, 0.3, bright + 0.2, 0.7}
end

function Voyager:draw()
    for _, L in ipairs(self.layers) do
        L:draw()
    end
end

