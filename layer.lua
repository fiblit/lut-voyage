local libclass = require("lib.class")
local transform = require("transform")
local anim = require("anim") -- to handle draw/construction

Layer = class()
function Layer:_new(img, transform, color, anchor)
    if type(img) == 'table' and img.is[Anim] then
        self.img = img:frame()
        self.anim = img
    else
        self.img = img
    end
    self.transform = transform
    self.anchor = anchor
    set.color = color

    -- default to identity
    if not self.transform then
        --self.transform = love.math.newTransform(0, 0)
        self.transform = Transform(0, 0)
    end

    if not self.color then
        self.color = {1, 1, 1, 1}
    end

    -- default to center anchor
    if not self.anchor then
        --self.anchor = love.math.newTransform(0, 0)
        self.anchor = Transform(0, 0)
        self:reanchor('center')
    end
end

function Layer:update(dt)
    if self.anim and self.anim:update(dt) then
        self.img = self.anim:frame()
    end
end

function Layer:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.img, self.transform:asmat() * self.anchor:asmat())
end

function Layer:reanchor(point, offset)
    local ox, oy
    if point == 'center' then
        ox, oy = self.img:getWidth()/2, self.img:getHeight()/2
    elseif point == 'topleft' then
        ox, oy = 0, 0
    elseif point == 'topright' then
        ox, oy = self.img:getWidth(), 0
    elseif point == 'top' then
        ox, oy = self.img:getWidth()/2, 0
    elseif point == 'left' then
        ox, oy = 0, self.img:getHeight()/2
    elseif point == 'right' then
        ox, oy = self.img:getWidth(), self.img:getHeight()/2
    elseif point == 'botright' then
        ox, oy = self.img:getWidth(), self.img:getHeight()
    elseif point == 'bot' then
        ox, oy = self.img:getWidth()/2, self.img:getHeight()
    elseif point == 'leftbot' then
        ox, oy = 0, self.img:getHeight()
    end
    if not offset then
        offset = {x=0,y=0}
    end
    self.anchor.ox = ox + offset.x
    self.anchor.oy = oy + offset.y
end

function Layer:shift(offset)
    self.anchor.ox = self.anchor.ox + offset.x
    self.anchor.oy = self.anchor.oy + offset.y
end

function Layer:rotate(r)
    self.transform.r = self.transform.r + r
end

